/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-2014, Open Source Modelica Consortium (OSMC),
 * c/o Linköpings universitet, Department of Computer and Information Science,
 * SE-58183 Linköping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF GPL VERSION 3 LICENSE OR
 * THIS OSMC PUBLIC LICENSE (OSMC-PL) VERSION 1.2.
 * ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES
 * RECIPIENT'S ACCEPTANCE OF THE OSMC PUBLIC LICENSE OR THE GPL VERSION 3,
 * ACCORDING TO RECIPIENTS CHOICE.
 *
 * The OpenModelica software and the Open Source Modelica
 * Consortium (OSMC) Public License (OSMC-PL) are obtained
 * from OSMC, either from the above address,
 * from the URLs: http://www.ida.liu.se/projects/OpenModelica or
 * http://www.openmodelica.org, and in the OpenModelica distribution.
 * GNU version 3 is obtained from: http://www.gnu.org/copyleft/gpl.html.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without
 * even the implied warranty of  MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE, EXCEPT AS EXPRESSLY SET FORTH
 * IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE CONDITIONS OF OSMC-PL.
 *
 * See the full OSMC Public License conditions for more details.
 *
 */

encapsulated package newBackendInline
" file:        newBackendInline.mo
  package:     newBackendInline
  description: inline functions

  RCS: $Id$

  This module contains data structures and functions for inline functions.

  The entry point is the inlineCalls function, or inlineCallsInFunctions
  "

public import BackendDAE;
public import DAE;
public import Inline;

protected import BackendDAEUtil;
protected import BackendDump;
protected import BackendDAEOptimize;
protected import BackendEquation;
protected import BackendInline;
protected import BackendVariable;
protected import BackendVarTransform;
protected import ComponentReference;
protected import DAEDump;
protected import DAEUtil;
protected import Debug;
protected import ExpressionDump;
protected import ExpressionSimplify;
protected import Flags;
protected import Global;
protected import InlineArrayEquations;
protected import List;
protected import Matching;
protected import SCode;
protected import Types;

// =============================================================================
// inline functions public
//
// =============================================================================
public function normalInlineFunctions
  input BackendDAE.BackendDAE inDAE;
  output BackendDAE.BackendDAE outDAE = inDAE;
algorithm
  // If debug flag inlineFunctions is set disable inlining
  if Flags.isSet(Flags.INLINE_FUNCTIONS)  then
    outDAE := inlineCallsBDAE({DAE.NORM_INLINE()}, inDAE);
  end if;
end normalInlineFunctions;


// =============================================================================
// inline calls stuff
//
// =============================================================================

protected function inlineCallsBDAE
"searches for calls where the inline flag is true, and inlines them"
  input list<DAE.InlineType> inITLst;
  input BackendDAE.BackendDAE inBackendDAE;
  output BackendDAE.BackendDAE outBackendDAE;
protected
  list<DAE.InlineType> itlst;
  Inline.Functiontuple tpl;
  BackendDAE.EqSystems eqs;
  BackendDAE.Shared shared;
algorithm
  try

    if Flags.isSet(Flags.DUMPBACKENDINLINE) then
      if Flags.getConfigEnum(Flags.INLINE_METHOD) == 1 then
        print("\n############ BackendInline Method: replace ############");
      elseif Flags.getConfigEnum(Flags.INLINE_METHOD) == 2 then
        print("\n############ BackendInline Method: append ############");
      end if;
    end if;

    shared := inBackendDAE.shared;
    eqs := inBackendDAE.eqs;
    tpl := (SOME(shared.functionTree), inITLst);
    if Flags.getConfigEnum(Flags.INLINE_METHOD) == 1 then
      eqs := List.map1(eqs, BackendInline.inlineEquationSystem, tpl);
    elseif Flags.getConfigEnum(Flags.INLINE_METHOD) == 2 then
      eqs := List.map1(eqs, inlineEquationSystem, (tpl,shared));
    end if;
    if Flags.isSet(Flags.DUMPBACKENDINLINE) then
      BackendDump.dumpEqSystems(eqs, "Result DAE after Inline.");
    end if;
    // TODO: use new BackendInline also for other parts
    shared.knownVars := BackendInline.inlineVariables(shared.knownVars, tpl);
    shared.externalObjects := BackendInline.inlineVariables(shared.externalObjects, tpl);
    shared.initialEqs := BackendInline.inlineEquationArray(shared.initialEqs, tpl);
    shared.removedEqs := BackendInline.inlineEquationArray(shared.removedEqs, tpl);

    outBackendDAE := BackendDAE.DAE(eqs, shared);
  else
    if Flags.isSet(Flags.FAILTRACE) then
        Debug.traceln("BackendInline.inlineCallsBDAE failed");
    end if;
    fail();
  end try;

  // fix "tuple = tuple" expression after inline functions
  outBackendDAE := BackendDAEOptimize.simplifyComplexFunction1(outBackendDAE, false);
end inlineCallsBDAE;

protected function inlineEquationSystem
  input BackendDAE.EqSystem eqs;
  input tuple<Inline.Functiontuple,BackendDAE.Shared> tpl_shard;
  output BackendDAE.EqSystem oeqs = eqs;
protected
  BackendDAE.EqSystem new;
  Boolean inlined=true;
  BackendDAE.EquationArray eqnsArray;
  BackendDAE.Shared shared;
  Inline.Functiontuple tpl;
algorithm
  (tpl, shared) := tpl_shard;
  //inlineVariables(oeqs.orderedVars, tpl);
  (eqnsArray, new, inlined, shared) := inlineEquationArray(oeqs.orderedEqs, tpl, shared);
  //inlineEquationArray(oeqs.removedEqs, tpl);
  if inlined then
    oeqs.orderedEqs := eqnsArray;
    new := inlineEquationSystem(new, (tpl, shared));
    oeqs := BackendDAEUtil.mergeEqSystems(new, oeqs);
  end if;
end inlineEquationSystem;

protected function inlineEquationArray "
function: inlineEquationArray
  inlines function calls in an equation array"
  input BackendDAE.EquationArray inEquationArray;
  input Inline.Functiontuple fns;
  input BackendDAE.Shared iShared;
  output BackendDAE.EquationArray outEquationArray;
  output BackendDAE.EqSystem outEqs;
  output Boolean oInlined;
  output BackendDAE.Shared shared = iShared;
protected
  Integer i1,i2,size;
  array<Option<BackendDAE.Equation>> eqarr;
algorithm
  try
    BackendDAE.EQUATION_ARRAY(size,i1,i2,eqarr) := inEquationArray;
    (outEqs, oInlined, shared) := inlineEquationOptArray(inEquationArray, fns, shared);
    outEquationArray := BackendDAE.EQUATION_ARRAY(size,i1,i2,eqarr);
 else
   if Flags.isSet(Flags.FAILTRACE) then
      Debug.trace("newBackendInline.inlineEquationArray failed\n");
   end if;
 end try;

end inlineEquationArray;

protected function inlineEquationOptArray
"functio: inlineEquationrOptArray
  inlines calls in a equation option"
  input BackendDAE.EquationArray inEqnArray;
  input Inline.Functiontuple fns;
  input BackendDAE.Shared iShared;
  output BackendDAE.EqSystem outEqs;
  output Boolean oInlined = false;
  output BackendDAE.Shared shared = iShared;
protected
  Option<BackendDAE.Equation> eqn;
  Boolean inlined;
  BackendDAE.EqSystem tmpEqs;
algorithm
  outEqs := BackendDAEUtil.createEqSystem( BackendVariable.listVar({}), BackendEquation.listEquation({}));
  for i in 1:inEqnArray.numberOfElement loop
    (eqn, tmpEqs, inlined, shared) := inlineEqOpt(inEqnArray.equOptArr[i], fns, shared);
    if inlined then
      outEqs := BackendDAEUtil.mergeEqSystems(tmpEqs, outEqs);
      arrayUpdate(inEqnArray.equOptArr, i, eqn);
      oInlined := true;
    end if;
  end for;
end inlineEquationOptArray;

protected function inlineEqOpt "
function: inlineEqOpt
  inlines function calls in equations"
  input Option<BackendDAE.Equation> inEquationOption;
  input Inline.Functiontuple inElementList;
  input BackendDAE.Shared iShared;
  output Option<BackendDAE.Equation> outEquationOption;
  output BackendDAE.EqSystem outEqs;
  output Boolean inlined;
  output BackendDAE.Shared shared = iShared;
protected
  BackendDAE.Equation eqn, eqn1;
algorithm
  outEqs := BackendDAEUtil.createEqSystem( BackendVariable.listVar({}), BackendEquation.listEquation({}));
  if isSome(inEquationOption) then
     SOME(eqn) := inEquationOption;
     (eqn1,outEqs,inlined,shared) := inlineEq(eqn,inElementList,outEqs,shared);

     // debug
     if Flags.isSet(Flags.DUMPBACKENDINLINE_VERBOSE) and inlined then
       print("Equation before inline: "+BackendDump.equationString(eqn)+"\n");
       BackendDump.dumpEqSystem(outEqs, "Tmp DAE after Inline Eqn: "+BackendDump.equationString(eqn1)+"\n");
     end if;
     outEquationOption  := SOME(eqn1);
  else
    outEquationOption := NONE();
    inlined := false;
  end if;
end inlineEqOpt;

protected function inlineEq "
  inlines function calls in equations"
  input BackendDAE.Equation inEquation;
  input Inline.Functiontuple fns;
  input BackendDAE.EqSystem inEqs;
  input BackendDAE.Shared iShared;
  output BackendDAE.Equation outEquation;
  output BackendDAE.EqSystem outEqs;
  output Boolean inlined;
  output BackendDAE.Shared shared = iShared;
protected
  Boolean setFlagForce = Flags.isSet(Flags.FORCE_INLINE_FUNCTIONS);
algorithm
  Flags.set(Flags.FORCE_INLINE_FUNCTIONS,false);
  (outEquation,outEqs,inlined) := matchcontinue(inEquation)
    local
      DAE.Exp e1,e2;
      DAE.ElementSource source;
      Boolean b1,b2,b3;
      BackendDAE.EquationAttributes attr;
      BackendDAE.Equation eqn;
      Integer size;
      list<DAE.Exp> explst;
      DAE.ComponentRef cref;
      BackendDAE.WhenEquation weq,weq_1;
      list<DAE.Statement> stmts, stmts1;
      DAE.Expand crefExpand;
      list<list<BackendDAE.Equation>> eqnslst;
      list<BackendDAE.Equation> eqns;

    case BackendDAE.EQUATION(e1,e2,source,attr)
      equation
        (e1,source,outEqs,b1,shared) = inlineCalls(e1,fns,source,inEqs,shared);
        (e2,source,outEqs,b2,shared) = inlineCalls(e2,fns,source,outEqs,shared);
        b3 = b1 or b2;
      then
        (BackendEquation.generateEquation(e1,e2,source,attr),outEqs,b3);

    case BackendDAE.COMPLEX_EQUATION(left=e1, right=e2, source=source, attr=attr)
      equation
        Flags.set(Flags.FORCE_INLINE_FUNCTIONS,setFlagForce);
        (e1,source,outEqs,b1,shared) = inlineCalls(e1,fns,source,inEqs,shared);
        (e2,source,outEqs,b2,shared) = inlineCalls(e2,fns,source,outEqs,shared);
        b3 = b1 or b2;
        if b2 and Expression.isScalar(e1) and Expression.isTuple(e2) then
          e2 = DAE.TSUB(e2, 1, Expression.typeof(e1));
        end if;
        Flags.set(Flags.FORCE_INLINE_FUNCTIONS,false);
      then
        (BackendEquation.generateEquation(e1,e2,source,attr),outEqs,b3);

    case BackendDAE.ARRAY_EQUATION(left=e1, right=e2, source=source, attr=attr)
      equation
        (e1,source,outEqs,b1,shared) = inlineCalls(e1,fns,source,inEqs,shared);
        (e2,source,outEqs,b2,shared) = inlineCalls(e2,fns,source,outEqs,shared);
         b3 = b1 or b2;
      then
        (BackendEquation.generateEquation(e1,e2,source,attr),outEqs,b3);

     case BackendDAE.SOLVED_EQUATION(cref,e2,source,attr)
       equation
       (e2,source,outEqs,b2,shared) = inlineCalls(e2,fns,source,inEqs,shared);
       then
        (BackendDAE.SOLVED_EQUATION(cref,e2,source,attr),outEqs,b2);

     case BackendDAE.RESIDUAL_EQUATION(e1,source,attr)
       equation
       (e1,source,outEqs,b1,shared) = inlineCalls(e1,fns,source,inEqs,shared);
     then
       (BackendDAE.RESIDUAL_EQUATION(e1,source,attr),outEqs,b1);

      case eqn as BackendDAE.ALGORITHM(size, DAE.ALGORITHM_STMTS(statementLst=stmts),source,crefExpand,attr)
      equation
        (stmts1,b1) = Inline.inlineStatements(stmts,fns,{},false);
        if b1 then
          eqn = BackendDAE.ALGORITHM(size,DAE.ALGORITHM_STMTS(stmts1),source,crefExpand,attr);
        end if;
      then
        (eqn,inEqs,b1);

     case eqn as BackendDAE.WHEN_EQUATION(size,weq,source,attr)
      equation
        (weq_1,source,b1) = BackendInline.inlineWhenEq(weq,fns,source);
        if b1 then
           eqn = BackendDAE.WHEN_EQUATION(size,weq_1,source,attr);
        end if;
      then
        (eqn,inEqs, b1);

     case eqn as BackendDAE.IF_EQUATION(explst,eqnslst,eqns,source,attr)
      equation
        (explst,source,b1) = Inline.inlineExps(explst,fns,source);
        (eqnslst,b2) = BackendInline.inlineEqsLst(eqnslst,fns,{},false);
        (eqns,b3) = BackendInline.inlineEqs(eqns,fns,{},false);
        b3 = b1 or b2 or b3;
        if b3 then
          eqn = BackendDAE.IF_EQUATION(explst,eqnslst,eqns,source,attr);
        end if;
      then
        (eqn, inEqs, b3);

     else (inEquation,inEqs,false);

  end matchcontinue;
  Flags.set(Flags.FORCE_INLINE_FUNCTIONS,setFlagForce);
end inlineEq;

protected function inlineCalls "
function: inlineCalls
  inlines calls in a DAE.Exp"
  input DAE.Exp inExp;
  input Inline.Functiontuple fns;
  input DAE.ElementSource inSource;
  input BackendDAE.EqSystem inEqs;
  input BackendDAE.Shared iShared;
  output DAE.Exp outExp;
  output DAE.ElementSource outSource;
  output BackendDAE.EqSystem outEqs;
  output Boolean inlined;
  output BackendDAE.Shared shared = iShared;
algorithm
  (outExp,outSource,outEqs,inlined) := matchcontinue (inExp)
    local
      DAE.Exp e,e1,e2;
      DAE.ElementSource source;
      list<DAE.Statement> assrtLst;
      Boolean b;

    case (e)
      equation
        (e1,(_,outEqs,b,_)) = Expression.traverseExpBottomUp(e,inlineCallsWork,(fns,inEqs,false,false));
        source = DAEUtil.addSymbolicTransformation(inSource,DAE.OP_INLINE(DAE.PARTIAL_EQUATION(e),DAE.PARTIAL_EQUATION(e1)));
        (DAE.PARTIAL_EQUATION(e2),source) = ExpressionSimplify.simplifyAddSymbolicOperation(DAE.PARTIAL_EQUATION(e1), source);
        // debug
        if Flags.isSet(Flags.DUMPBACKENDINLINE_VERBOSE) then
          print("\ninExp: " + ExpressionDump.printExpStr(inExp));
          print("\noutExp: " + ExpressionDump.printExpStr(e2));
        end if;
      then
        (e2,source,outEqs,b);

    else (inExp,inSource,inEqs,false);
  end matchcontinue;
end inlineCalls;

protected function inlineCallsWork
"replaces an expression call with the statements from the function"
  input DAE.Exp inExp;
  input tuple<Inline.Functiontuple,BackendDAE.EqSystem,Boolean,Boolean> inTuple;
  output DAE.Exp outExp;
  output tuple<Inline.Functiontuple,BackendDAE.EqSystem,Boolean,Boolean> outTuple;
algorithm
  (outExp,outTuple) := matchcontinue (inExp,inTuple)
    local
      Inline.Functiontuple fns,fns1;
      list<DAE.Element> fn;
      Absyn.Path p;
      list<DAE.Exp> args;
      list<DAE.ComponentRef> outputCrefs;
      list<tuple<DAE.ComponentRef, DAE.Exp>> argmap;
      list<DAE.ComponentRef> lst_cr;
      DAE.ElementSource source;
      DAE.Exp newExp,newExp1, e1, cond, msg, level, newAssrtCond, newAssrtMsg, newAssrtLevel, e2, e3;
      DAE.InlineType inlineType;
      DAE.Statement assrt;
      HashTableCG.HashTable checkcr;
      list<DAE.Statement> stmts,assrtStmts, assrtLstIn, assrtLst;
      Boolean generateEvents, b, b1;
      Boolean inCoplexFunction, inArrayEq;
      Option<SCode.Comment> comment;
      DAE.Type ty;
      String funcname;
      BackendDAE.EqSystem eqSys, newEqSys;
      Boolean insideIfExp;

    case (e1 as DAE.IFEXP(), (fns,eqSys,b,insideIfExp))
      then fail();

    case (DAE.CALL(attr=DAE.CALL_ATTR(builtin=true)),_)
      then (inExp,inTuple);

    case (e1 as DAE.CALL(p,args,DAE.CALL_ATTR(ty=ty,inlineType=inlineType)),(fns,eqSys,b,false))
    guard (Flags.isSet(Flags.FORCE_INLINE_FUNCTIONS) or Inline.checkInlineType(inlineType,fns)) and Flags.getConfigEnum(Flags.INLINE_METHOD)==2
      equation
        (fn,comment) = Inline.getFunctionBody(p,fns);
        funcname = Util.modelicaStringToCStr(Absyn.pathString(p), false);
        if Flags.isSet(Flags.DUMPBACKENDINLINE_VERBOSE) then
          print("Inline Function " +funcname+" type: "+DAEDump.dumpInlineTypeStr(inlineType)+"\n");
          print("in : " + ExpressionDump.printExpStr(inExp) + "\n");
        end if;

        // get inputs, body and output
        (outputCrefs, newEqSys) = createEqnSysfromFunction(fn,args,funcname);
        newExp = Expression.makeTuple(list( Expression.crefExp(cr) for cr in outputCrefs));
        if Flags.isSet(Flags.DUMPBACKENDINLINE_VERBOSE) then
          print("out: " + ExpressionDump.printExpStr(newExp) + "\n");
        end if;

        // MSL 3.2.1 need GenerateEvents to disable this
        if not Inline.hasGenerateEventsAnnotation(comment) then
          _ = BackendDAEUtil.traverseBackendDAEExpsEqSystemWithUpdate(newEqSys, addNoEvent, false);
        end if;
        newEqSys = BackendDAEUtil.mergeEqSystems(newEqSys, eqSys);
      then
        (newExp,(fns,newEqSys,true,false));

    //fallback use old implementation
    case (e1 as DAE.CALL(p,args,DAE.CALL_ATTR(ty=ty,inlineType=inlineType)),(fns,eqSys,b,insideIfExp))
      equation

        if not Flags.isSet(Flags.FORCE_INLINE_FUNCTIONS) then
          (newExp, (_, b1, _)) = Inline.inlineCall(inExp,(fns,false,{}));
        else
          (newExp, (_, b1, _)) = Inline.forceInlineCall(inExp,(fns,false,{}));
        end if;

        if Flags.isSet(Flags.DUMPBACKENDINLINE_VERBOSE) then
          funcname = Util.modelicaStringToCStr(Absyn.pathString(p), false);
          print("\nBackendInline fallback replace implementation: " +funcname+" type: " +DAEDump.dumpInlineTypeStr(inlineType)+"\n");
          print("in : " + ExpressionDump.printExpStr(inExp) + "\n");
          print("out: " + ExpressionDump.printExpStr(newExp) + "\n");
        end if;
      then (newExp,(fns,eqSys,b or b1,insideIfExp));

    else (inExp,inTuple);
  end matchcontinue;
end inlineCallsWork;

function addNoEvent
  input DAE.Exp inExp;
  input Boolean inB;
  output DAE.Exp outExp;
  output Boolean outB = inB;
algorithm
  outExp := Expression.addNoEventToRelationsAndConds(inExp);
  outExp := Expression.addNoEventToEventTriggeringFunctions(outExp);
end addNoEvent;

protected function createReplacementVariables
  input DAE.ComponentRef inCref;
  input String funcName;
  input BackendVarTransform.VariableReplacements inRepls;
  output DAE.ComponentRef crVar;
  output list<BackendDAE.Var> outVars = {};
  output BackendVarTransform.VariableReplacements outRepls = inRepls;
protected
  DAE.Exp eVar, e;
  list<DAE.Exp> arrExp;
  list<DAE.ComponentRef> crefs, crefs1;
  DAE.ComponentRef cr;
  BackendDAE.Var var;
algorithm
  // create variable and expression from cref
  var := BackendVariable.createTmpVar(inCref, funcName);
  crVar := BackendVariable.varCref(var);
  eVar := Expression.crefExp(crVar);

  //TODO: handle record cases
  false := Expression.isRecord(eVar);

  // create top-level replacement
  outRepls := BackendVarTransform.addReplacement(outRepls, inCref, eVar, NONE());

  // handle array cases for replacements
  crefs := ComponentReference.expandCref(inCref, false);
  crefs1 := ComponentReference.expandCref(crVar, false);
  try
    arrExp := Expression.getArrayOrRangeContents(eVar);
  else
    arrExp := {eVar};
  end try;

  // error handling
  if listLength(crefs) <> listLength(arrExp) then
    if Flags.isSet(Flags.FAILTRACE) then
      Debug.traceln("BackendInline.createReplacementVariables failed with array handling "+ExpressionDump.printExpStr(eVar)+"\n");
    end if;
    fail();
  end if;

  // add every array scalar to replacements
  for c in crefs loop
    cr :: crefs1 := crefs1;
    e :: arrExp := arrExp;
    var.varName := cr;
    outVars := var::outVars;
    outRepls := BackendVarTransform.addReplacement(outRepls, c, e, NONE());
  end for;
  outVars := listReverse(outVars);
end createReplacementVariables;

protected function createEqnSysfromFunction
  input list<DAE.Element> fns;
  input list<DAE.Exp> inArgs;
  input String funcname;
  output list<DAE.ComponentRef> oOutput = {};
  output BackendDAE.EqSystem outEqs;
protected
  list<DAE.Exp> args = inArgs, left_lst;
  BackendVarTransform.VariableReplacements repl;
  list<DAE.ComponentRef> fnInputs = {};
  DAE.Type tp;
  list<tuple<DAE.ComponentRef, DAE.Exp>> argmap;
  HashTableCG.HashTable checkcr;
  list<DAE.ComponentRef> tmpOutput = {};
  DAE.ComponentRef cr;
  BackendDAE.Var var;
  BackendDAE.IncidenceMatrix m;
  array<Integer> ass1, ass2;
  list<BackendDAE.Equation> eqlst = {};
algorithm
  if Flags.isSet(Flags.DUMPBACKENDINLINE_VERBOSE) then
    print("\ncreate EqnSys from function: "+funcname);
  end if;
  outEqs := BackendDAEUtil.createEqSystem( BackendVariable.listVar({}), BackendEquation.listEquation({}));
  repl := BackendVarTransform.emptyReplacements();

  for fn in fns loop
  _ := match(fn)
    local
      DAE.ComponentRef crVar;
      list<DAE.Statement> st;
      DAE.Exp eVar, eBind, e;
      list<DAE.Exp> arrExp;
      BackendDAE.Equation eq;
      Integer varDim;
      list<DAE.ComponentRef> crefs;
      Integer n,i;
      DAE.Dimensions dims;
      DAE.Dimension dim;
      list<BackendDAE.Var> varLst;

    // assume inArgs is syncron to fns.inputs
    case (DAE.VAR(componentRef=cr,direction=DAE.INPUT(),kind=DAE.VARIABLE()))
      algorithm
        fnInputs := cr :: fnInputs;
      then ();

    //fns.outputs
    case DAE.VAR(componentRef=cr,direction=DAE.OUTPUT(),kind=DAE.VARIABLE())
    guard (not Expression.isRecordType(ComponentReference.crefTypeFull(cr))) and ComponentReference.crefDepth(cr) > 0
	    algorithm
	      // create variables
	      (crVar, varLst, repl) := createReplacementVariables(cr, funcname, repl);
	      outEqs := BackendVariable.addVarsDAE(varLst, outEqs);
	      // collect output variables
	      oOutput := crVar::oOutput;
      then ();

    case (DAE.VAR(componentRef=cr,protection=DAE.PROTECTED(),binding=NONE()))
    guard not Expression.isRecordType(ComponentReference.crefTypeFull(cr))
      algorithm
        // create variables
        (crVar, varLst, repl) := createReplacementVariables(cr, funcname, repl);
        varLst := list(BackendVariable.setVarTS(_var, SOME(BackendDAE.AVOID())) for _var in varLst);
        outEqs := BackendVariable.addVarsDAE(varLst, outEqs);
    then ();

    case (DAE.VAR(componentRef=cr,protection=DAE.PROTECTED(),binding=SOME(eBind)))
    guard not Expression.isRecordType(ComponentReference.crefTypeFull(cr))
      algorithm
        // create variables
	      (crVar, varLst, repl) := createReplacementVariables(cr, funcname, repl);
	      // add variables
	      eVar := Expression.crefExp(crVar);
	      varLst := list(BackendVariable.setVarTS(_var, SOME(BackendDAE.AVOID())) for _var in varLst);
        outEqs := BackendVariable.addVarsDAE(varLst, outEqs);
        // add equation for binding
	      eq := BackendEquation.generateEquation(eVar,eBind);
	      outEqs := BackendEquation.equationAddDAE(eq, outEqs);
      then ();

    case (DAE.ALGORITHM(algorithm_ = DAE.ALGORITHM_STMTS(st)))
      equation
	      eqlst = List.map(st, BackendEquation.statementEq);
	      outEqs = BackendEquation.equationsAddDAE(eqlst, outEqs);
      then ();
    end match;
  end for;

  // bring output variables in the right order
  oOutput := listReverse(oOutput);

  /* TODO: remove this check for a square system */
  if (BackendDAEUtil.systemSize(outEqs) <> BackendVariable.daenumVariables(outEqs)) then
    if Flags.isSet(Flags.FAILTRACE) then
      Debug.trace("newBackendInline.createEqnSysfromFunction failed for function " + funcname + "with different sizes\n");
      print(intString(BackendDAEUtil.systemSize(outEqs)) + " <> "  + intString(BackendVariable.daenumVariables(outEqs)));
    end if;
    fail();
  end if;

  // debug
  if Flags.isSet(Flags.DUMPBACKENDINLINE_VERBOSE) then
    print("\noriginal function body of: "+funcname);
    BackendDump.printEqSystem(outEqs);
    print("\nDump replacements: ");
    BackendVarTransform.dumpReplacements(repl);
  end if;

  // scalarize array equations
  outEqs.orderedEqs := BackendEquation.listEquation(InlineArrayEquations.getScalarArrayEqns(BackendEquation.equationList(outEqs.orderedEqs)));

  // replace protected and output variables in function body
  outEqs := BackendVarTransform.performReplacementsEqSystem(outEqs, repl);

  // debug
  if Flags.isSet(Flags.DUMPBACKENDINLINE_VERBOSE) then
    print("\n replaced protected and output for: "+funcname);
    BackendDump.printEqSystem(outEqs);
  end if;


  // replace inputs variables
  argmap := List.threadTuple(listReverse(fnInputs), args);
  (argmap,checkcr) := Inline.extendCrefRecords(argmap, HashTableCG.emptyHashTable());
  BackendDAEUtil.traverseBackendDAEExpsEqSystemWithUpdate(outEqs, replaceArgs, (argmap,checkcr,true));


  // debug
  if Flags.isSet(Flags.DUMPBACKENDINLINE_VERBOSE) then
    print("\nreplaced input arguments for: "+funcname);
    BackendDump.printEqSystem(outEqs);
  end if;


 //reduce system
/*

  if Expression.isTuple(ohs) then
    DAE.TUPLE(PR = left_lst) := ohs;
    for e in left_lst loop
      cr :: oOutput := oOutput;
      var :: vars := vars;
      if not Expression.isWild(e) then
        vars2 := var :: vars2;
        tmpOutput := cr :: tmpOutput;
      else
        tmpOutput := DAE.WILD() :: tmpOutput;
      end if;
    end for;
   oOutput := listReverse(tmpOutput);
   vars := vars2;
  end if;


  try
   (_, m, ) :=  BackendDAEUtil.getIncidenceMatrix(outEqs, BackendDAE.NORMAL(), SOME(shared.functionTree));
    //BackendDump.dumpIncidenceMatrix(m);
   (ass1, ass2) := Matching.PerfectMatching(m);
   //BackendDump.dumpMatching(ass1);
   //BackendDump.dumpMatching(ass2);
   outEqs.matching := BackendDAE.MATCHING(ass1, ass2, {});
   (outEqs) := BackendDAEUtil.tryReduceEqSystem(outEqs, shared, vars);

   if Flags.isSet(Flags.DUMPBACKENDINLINE) then
     print("\nfunction body reduced: "+funcname);
     BackendDump.printEqSystem(outEqs);
     print("\nEnd: "+funcname);
   end if;
  else
  end try;
*/

end createEqnSysfromFunction;

protected function addReplacement
  input DAE.ComponentRef iCr;
  input DAE.Exp iExp;
  input BackendVarTransform.VariableReplacements iRepl;
  output BackendVarTransform.VariableReplacements oRepl;
algorithm
  oRepl := match(iCr,iExp,iRepl)
    local
      DAE.Type tp;
      BackendVarTransform.VariableReplacements repl;
      list<DAE.ComponentRef> crefs;
      list<DAE.Exp> arrExp;
      DAE.Exp e;

    case (DAE.CREF_IDENT(identType=tp),_,_)
      guard not Expression.isRecordType(tp) and not Expression.isArrayType(tp)
    then BackendVarTransform.addReplacement(iRepl, iCr, iExp, NONE());

    case (DAE.CREF_IDENT(identType=tp),_,_)
      guard Expression.isArrayType(tp)
      algorithm
        crefs := ComponentReference.expandCref(iCr, false);
        repl := iRepl;
        arrExp := Expression.getArrayOrRangeContents(iExp);
        for c in crefs loop
          e :: arrExp := arrExp;
          repl := BackendVarTransform.addReplacement(repl, c, e, NONE());
        end for;
    then repl;
   else fail();
  end match;
end addReplacement;

protected function replaceArgs
"finds DAE.CREF and replaces them with new exps if the cref is in the argmap"
  input DAE.Exp inExp;
  input tuple<list<tuple<DAE.ComponentRef,DAE.Exp>>,HashTableCG.HashTable,Boolean> inTuple;
  output DAE.Exp outExp;
  output tuple<list<tuple<DAE.ComponentRef,DAE.Exp>>,HashTableCG.HashTable,Boolean> outTuple;
algorithm
  (outExp,outTuple) := Expression.Expression.traverseExpBottomUp(inExp,Inline.replaceArgs,inTuple);
  if not Util.tuple33(outTuple) then
    if Flags.isSet(Flags.FAILTRACE) then
      Debug.traceln("BackendInline.replaceArgs failed");
    end if;
    fail();
  end if;
end replaceArgs;

annotation(__OpenModelica_Interface="backend");
end newBackendInline;
