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
protected import DAEUtil;
protected import Debug;
protected import ExpressionDump;
protected import ExpressionSimplify;
protected import Flags;
protected import Global;
protected import InlineArrayEquations;
protected import List;
protected import SCode;
protected import Types;

// =============================================================================
// inline functions stuff
//
// =============================================================================
public function normalInlineFunctions
  input BackendDAE.BackendDAE inDAE;
  output BackendDAE.BackendDAE outDAE;
algorithm
  outDAE := inlineCallsBDAE({DAE.NORM_INLINE()}, inDAE);
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
algorithm
  outBackendDAE := matchcontinue(inBackendDAE)
    local
      list<DAE.InlineType> itlst;
      Inline.Functiontuple tpl;
      BackendDAE.EqSystems eqs;
      BackendDAE.Shared shared;

    case BackendDAE.DAE(eqs, shared)
    algorithm
      tpl := (SOME(shared.functionTree), inITLst);
      eqs := List.map1(listReverse(eqs), inlineEquationSystem, tpl);
      // ToDo
      shared.knownVars := BackendInline.inlineVariables(shared.knownVars, tpl);
      shared.externalObjects := BackendInline.inlineVariables(shared.externalObjects, tpl);
      shared.initialEqs := BackendInline.inlineEquationArray(shared.initialEqs, tpl);
      shared.removedEqs := BackendInline.inlineEquationArray(shared.removedEqs, tpl);
      //shared.eventInfo := BackendInline.inlineEventInfo(shared.eventInfo, tpl);
    then
      BackendDAE.DAE(eqs, shared);

      else
      algorithm
        true := Flags.isSet(Flags.FAILTRACE);
        Debug.traceln("Inline.inlineCalls failed");
      then
        fail();
  end matchcontinue;

  outBackendDAE := BackendDAEOptimize.simplifyComplexFunction1(outBackendDAE);
end inlineCallsBDAE;

protected function inlineEquationSystem
  input BackendDAE.EqSystem eqs;
  input Inline.Functiontuple tpl;
  output BackendDAE.EqSystem oeqs = eqs;
protected
  BackendDAE.EqSystem new;
  Boolean inlined=true;
  BackendDAE.EquationArray eqnsArray;
algorithm
  //inlineVariables(oeqs.orderedVars, tpl);
    (eqnsArray, new, inlined) := inlineEquationArray(oeqs.orderedEqs, tpl);
  if inlined then
    new := inlineEquationSystem(new, tpl);
  end if;
  //inlineEquationArray(oeqs.removedEqs, tpl);
  oeqs.orderedEqs := eqnsArray;
  oeqs := BackendDAEUtil.mergeEqSystems(new, oeqs);
end inlineEquationSystem;

protected function inlineEquationArray "
function: inlineEquationArray
  inlines function calls in an equation array"
  input BackendDAE.EquationArray inEquationArray;
  input Inline.Functiontuple inElementList;
  output BackendDAE.EquationArray outEquationArray;
  output BackendDAE.EqSystem outEqs;
  output Boolean oInlined;
algorithm
  (outEquationArray,outEqs,oInlined) := matchcontinue(inEquationArray,inElementList)
    local
      Inline.Functiontuple fns;
      Integer i1,i2,size;
      array<Option<BackendDAE.Equation>> eqarr;
    case(BackendDAE.EQUATION_ARRAY(size,i1,i2,eqarr),fns)
      equation
        (outEqs, oInlined) = inlineEquationOptArray(eqarr,i2,fns);
      then
        (BackendDAE.EQUATION_ARRAY(size,i1,i2,eqarr),outEqs,oInlined);
        else
      equation
        true = Flags.isSet(Flags.FAILTRACE);
        Debug.trace("newBackendInline.inlineEquationArray failed\n");
      then
        fail();
  end matchcontinue;
end inlineEquationArray;

protected function inlineEquationOptArray
"functio: inlineEquationrOptArray
  inlines calls in a equation option"
  input array<Option<BackendDAE.Equation>> inEqnArray;
  input Integer arraysize;
  input Inline.Functiontuple fns;
  output BackendDAE.EqSystem outEqs;
  output Boolean oInlined = false;
protected
  Option<BackendDAE.Equation> eqn;
  Boolean inlined;
algorithm
  outEqs := BackendDAEUtil.createEqSystem( BackendVariable.listVar({}), BackendEquation.listEquation({}));
  for i in 1:arraysize loop
  (eqn, outEqs, inlined) := inlineEqOpt(inEqnArray[i], fns, outEqs);

    if inlined then
      arrayUpdate(inEqnArray, i, eqn);
      oInlined := true;
    end if;
  end for;
end inlineEquationOptArray;

protected function inlineEqOpt "
function: inlineEqOpt
  inlines function calls in equations"
  input Option<BackendDAE.Equation> inEquationOption;
  input Inline.Functiontuple inElementList;
  input BackendDAE.EqSystem inEqs;
  output Option<BackendDAE.Equation> outEquationOption;
  output BackendDAE.EqSystem outEqs;
  output Boolean inlined;
algorithm
  (outEquationOption,outEqs,inlined) := match(inEquationOption,inElementList)
    local
      BackendDAE.Equation eqn;
      Boolean b;
    case(NONE(),_) then (NONE(),inEqs,false);
    case(SOME(eqn),_)
      equation
        (eqn,outEqs,b) = inlineEq(eqn,inElementList,inEqs);
      then
        (SOME(eqn),outEqs,b);
  end match;
end inlineEqOpt;

protected function inlineEq "
  inlines function calls in equations"
  input BackendDAE.Equation inEquation;
  input Inline.Functiontuple fns;
  input BackendDAE.EqSystem inEqs;
  output BackendDAE.Equation outEquation;
  output BackendDAE.EqSystem outEqs;
  output Boolean inlined;
algorithm
   //BackendDump.printEquation(inEquation);
  (outEquation,outEqs,inlined) := matchcontinue(inEquation)
    local
      DAE.Exp e1,e2;
      DAE.ElementSource source;
      Boolean b1,b2,b3;
      BackendDAE.EquationAttributes attr;
      BackendDAE.Equation eqn;

    case BackendDAE.EQUATION(e1,e2,source,attr)
      equation
        //print("\neq:");
        //BackendDump.printEquation(inEquation);
        (e1,source,outEqs,b1) = inlineCalls(e1,fns,source,inEqs);
        (e2,source,outEqs,b2) = inlineCalls(e2,fns,source,outEqs);
        b3 = b1 or b2;
        //eqn = BackendEquation.generateEquation(e1,e2,source,attr);
        //BackendDump.printEquation(eqn);
      then
        (BackendEquation.generateEquation(e1,e2,source,attr),outEqs,b3);

    case BackendDAE.COMPLEX_EQUATION(left=e1, right=e2, source=source, attr=attr)
      equation
        //print("\nceq:");
        //BackendDump.printEquation(inEquation);
        (e1,source,outEqs,b1) = inlineCalls(e1,fns,source,inEqs,true);
        (e2,source,outEqs,b2) = inlineCalls(e2,fns,source,outEqs,true);
        b3 = b1 or b2;
        if b2 and Expression.isScalar(e1) and Expression.isTuple(e2) then
          e2 = Expression.makeASUB(e2,  {DAE.ICONST(1)});
          //print("\nceq:");
          //eqn = BackendEquation.generateEquation(e1,e2,source,attr);
          //BackendDump.printEquation(eqn);
        end if;
      then
        (BackendEquation.generateEquation(e1,e2,source,attr),outEqs,b3);

    case BackendDAE.ARRAY_EQUATION(left=e1, right=e2, source=source, attr=attr)
      equation
        (e1,source,outEqs,b1) = inlineCalls(e1,fns,source,inEqs);
        (e2,source,outEqs,b2) = inlineCalls(e2,fns,source,outEqs);
         b3 = b1 or b2;
        //if b3 then
        //print("\naeq:");
        //BackendDump.printEquation(inEquation);
        //print("\naeq':");
        //BackendDump.printEquation(BackendEquation.generateEquation(e1,e2,source,attr));
        //BackendDump.printEqSystem(outEqs);

        //end if;
      then
        (BackendEquation.generateEquation(e1,e2,source,attr),outEqs,b3);

     else (inEquation,inEqs,false);


  end matchcontinue;
end inlineEq;

protected function inlineCalls "
function: inlineCalls
  inlines calls in a DAE.Exp"
  input DAE.Exp inExp;
  input Inline.Functiontuple fns;
  input DAE.ElementSource inSource;
  input BackendDAE.EqSystem inEqs;
  input Boolean inCoplexFunction = false;
  output DAE.Exp outExp;
  output DAE.ElementSource outSource;
  output BackendDAE.EqSystem outEqs;
  output Boolean inlined;
algorithm
  (outExp,outSource,outEqs,inlined) := matchcontinue (inExp)
    local
      DAE.Exp e,e1,e2;
      DAE.ElementSource source;
      list<DAE.Statement> assrtLst;

      // never inline WILD!
    case (DAE.CREF(componentRef = DAE.WILD())) then (inExp,inSource,inEqs,false);

    case (e)
      equation
        //print("\ninExp: " + ExpressionDump.printExpStr(e));
        (e1,(_,outEqs,true,_)) = Expression.traverseExpBottomUp(e,inlineCallsWork,(fns,inEqs,false,inCoplexFunction));
        source = DAEUtil.addSymbolicTransformation(inSource,DAE.OP_INLINE(DAE.PARTIAL_EQUATION(e),DAE.PARTIAL_EQUATION(e1)));
        (DAE.PARTIAL_EQUATION(e2),source) = ExpressionSimplify.simplifyAddSymbolicOperation(DAE.PARTIAL_EQUATION(e1), source);
        //print("\noutExp: " + ExpressionDump.printExpStr(e));
      then
        (e2,source,outEqs,true);

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
      DAE.Exp newExp,newExp1, e1, cond, msg, level, newAssrtCond, newAssrtMsg, newAssrtLevel;
      DAE.InlineType inlineType;
      DAE.Statement assrt;
      HashTableCG.HashTable checkcr;
      list<DAE.Statement> stmts,assrtStmts, assrtLstIn, assrtLst;
      Boolean generateEvents;
      Boolean inCoplexFunction, inArrayEq;
      Option<SCode.Comment> comment;
      DAE.Type ty;
      String funcname;
      BackendDAE.EqSystem eqSys, newEqSys;

      // If we disable inlining by use of flags, we still inline builtin functions
    case (_,_)
	guard not Flags.isSet(Flags.INLINE_FUNCTIONS)
      then (inExp,inTuple);

    case (e1 as DAE.CALL(p,args,DAE.CALL_ATTR(ty=ty,inlineType=inlineType)),(fns,eqSys,_,inCoplexFunction))
	guard Inline.checkInlineType(inlineType,fns) or inCoplexFunction
      equation
        (fn,comment) = Inline.getFunctionBody(p,fns);
        funcname = Util.modelicaStringToCStr(Absyn.pathString(p), false);

        // get inputs, body and output
        (outputCrefs, newEqSys) = createEqnSysfromFunction(fn,args,funcname);
        newExp = Expression.makeTuple(list( Expression.crefExp(cr) for cr in outputCrefs));
        //print("out:" + ExpressionDump.printExpStr(newExp) + "\n");

        // MSL 3.2.1 need GenerateEvents to disable this
        if not Inline.hasGenerateEventsAnnotation(comment) then
          _ = BackendDAEUtil.traverseBackendDAEExpsEqSystemWithUpdate(newEqSys, addNoEvent, false);
        end if;

        // merge EqSystems
        eqSys = BackendDAEUtil.mergeEqSystems(newEqSys,eqSys);
      then
        (newExp,(fns,eqSys,true,inCoplexFunction));
   //fallback
   case (e1 as DAE.CALL(p,args,DAE.CALL_ATTR(ty=ty,inlineType=inlineType)),(fns,eqSys,_,inCoplexFunction))
      equation
	//print("\n ############## \n");
        //print("in:" + ExpressionDump.printExpStr(inExp) + "\n");
        if inCoplexFunction then
      	  newExp = Inline.inlineCall(inExp,(fns,false,{}));
        else
      	  newExp = Inline.forceInlineCall(inExp,(fns,false,{}));
        end if;
        //print("out:" + ExpressionDump.printExpStr(newExp) + "\n");
      then (newExp,(fns,eqSys,true,inCoplexFunction));

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

protected function createEqnSysfromFunction
  input list<DAE.Element> fns;
  input list<DAE.Exp> inArgs;
  input String funcname;
  output list<DAE.ComponentRef> oOutput = {};
  output BackendDAE.EqSystem outEqs;
  protected
  list<DAE.Exp> args = inArgs;
  BackendVarTransform.VariableReplacements repl;
  DAE.Type tp;
algorithm
  outEqs := BackendDAEUtil.createEqSystem( BackendVariable.listVar({}), BackendEquation.listEquation({}));
  repl := BackendVarTransform.emptyReplacements();

  for fn in fns loop
  _ := match(fn)
    local
      DAE.ComponentRef cr, crVar;
      list<DAE.Statement> st;
      DAE.Exp eVar, eBind, e;
      list<DAE.Exp> arrExp;
      BackendDAE.Var var;
      BackendDAE.Equation eq;
      list<BackendDAE.Equation> eqlst;
      Integer varDim;
      list<DAE.ComponentRef> crefs;
      Integer n,i;
      DAE.Dimensions dims;
      DAE.Dimension dim;

      /* assume inArgs is syncron to fns.inputs */
    case (DAE.VAR(componentRef=cr,direction=DAE.INPUT(),ty=tp, kind=DAE.VARIABLE()))
    guard not Expression.isRecordType(tp)
      algorithm
//expHasFunCall
      eVar::args := args;
      //false := Expression.isArray(eVar);
      false := Expression.isRecord(eVar);

      repl := addReplacement(cr, eVar,repl);
      repl := BackendVarTransform.addReplacement(repl, cr, eVar, NONE());
      //print("\n" +ExpressionDump.printExpStr(Expression.crefExp(cr)) + "--" + ExpressionDump.printExpStr(eVar) + "\n");
      then ();

    case DAE.VAR(componentRef=cr,direction=DAE.OUTPUT(),ty=tp,kind=DAE.VARIABLE())
    guard not Expression.isRecordType(tp)
	    algorithm
	      var := BackendVariable.createTmpVar(cr, funcname);

	      crVar := BackendVariable.varCref(var);
	      eVar := Expression.crefExp(crVar);
              false := Expression.isRecord(eVar);

	      repl := BackendVarTransform.addReplacement(repl, cr, eVar, NONE());

	      oOutput := crVar::oOutput;

	      varDim := BackendVariable.varDim(var);
	      if varDim == 1 then
	        outEqs := BackendVariable.addVarDAE(var, outEqs);
	        else
	          crefs := ComponentReference.expandCref(crVar, false);
	          for c in crefs loop
	            var.varName := c;
	            outEqs := BackendVariable.addVarDAE(var, outEqs);
	          end for;
                repl := addReplacement(cr, eVar,repl);
	      end if;
      then ();

    case (DAE.VAR(componentRef=cr,protection=DAE.PROTECTED(),ty=tp,binding=NONE()))
    guard not Expression.isRecordType(tp)
      algorithm
        var := BackendVariable.createTmpVar(cr, funcname);
	crVar := BackendVariable.varCref(var);
	eVar := Expression.crefExp(crVar);
        false := Expression.isRecord(eVar);
	//print(ExpressionDump.printExpStr(Expression.crefExp(cr)) + "--In\n");
	repl := BackendVarTransform.addReplacement(repl, cr, eVar, NONE());
	oOutput := crVar::oOutput;

	varDim := BackendVariable.varDim(var);

	if varDim == 1 then
	  outEqs := BackendVariable.addVarDAE(var, outEqs);
	else
	  crefs := ComponentReference.expandCref(crVar, false);
	  for c in crefs loop
	    var.varName := c;
	    outEqs := BackendVariable.addVarDAE(var, outEqs);
	  end for;
          repl := addReplacement(cr, eVar,repl);
	end if;

      then ();

    case (DAE.VAR(componentRef=cr,protection=DAE.PROTECTED(),ty=tp,binding=SOME(eBind)))
    guard not Expression.isRecordType(tp)
      algorithm

      var := BackendVariable.createTmpVar(cr, funcname);

      crVar := BackendVariable.varCref(var);
      eVar := Expression.crefExp(crVar);
      false := Expression.isRecord(eVar);
      repl := BackendVarTransform.addReplacement(repl, cr, eVar, NONE());

      varDim := BackendVariable.varDim(var);

      if varDim == 1 then
        outEqs := BackendVariable.addVarDAE(var, outEqs);
      else
	crefs := ComponentReference.expandCref(crVar, false);
	for c in crefs loop
          var.varName := c;
	  outEqs := BackendVariable.addVarDAE(var, outEqs);
	end for;
        repl := addReplacement(cr, eVar,repl);
      end if;

      repl := BackendVarTransform.addReplacement(repl, cr, eVar, NONE());
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
  oOutput := listReverse(oOutput);
  //print("\nend: "+funcname);
  //BackendDump.printEqSystem(outEqs);
  outEqs.orderedEqs := BackendEquation.listEquation(InlineArrayEquations.getScalarArrayEqns(BackendEquation.equationList(outEqs.orderedEqs)));

  if (BackendDAEUtil.systemSize(outEqs) <> BackendVariable.daenumVariables(outEqs)) or BackendDAEUtil.traverseBackendDAEExpsEqSystem(outEqs, hasSumCall, false) then
    if Flags.isSet(Flags.FAILTRACE) then
      Debug.trace("newBackendInline.createEqnSysfromFunction failed for function " + funcname + "with different sizes\n");
      print(intString(BackendDAEUtil.systemSize(outEqs)) + " <> "  + intString(BackendVariable.daenumVariables(outEqs)));
    end if;
    fail();
  end if;



    //outEqs := BackendVarTransform.performReplacementsEqSystem(outEqs, repl);
    outEqs := BackendVarTransform.performReplacementsEqSystem(outEqs, repl);
    //print("\nrepl: "+funcname);
    //BackendVarTransform.dumpReplacements(repl);
    //print("\nupdated: "+funcname);
    //BackendDump.printEqSystem(outEqs);

end createEqnSysfromFunction;

protected function hasSumCall
  input DAE.Exp inExp;
  input Boolean inB;
  output DAE.Exp outExp = inExp;
  output Boolean outB = inB;
protected
  list<DAE.Exp> arrExp;
algorithm
  outB := if outB then outB else Expression.expHasFunCall(inExp, "sum");
  outB := if outB then outB else Expression.expHasFunCall(inExp, "product");
  //print(ExpressionDump.printExpStr(inExp) + "--In\n");
end hasSumCall;

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

annotation(__OpenModelica_Interface="backend");
end newBackendInline;
