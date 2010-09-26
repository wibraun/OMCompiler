// This file defines templates for transforming Modelica/MetaModelica code to C
// code. They are used in the code generator phase of the compiler to write
// target code.
//
// There are two root templates intended to be called from the code generator:
// translateModel and translateFunctions. These templates do not return any
// result but instead write the result to files. All other templates return
// text and are used by the root templates (most of them indirectly).
//
// To future maintainers of this file:
//
// - A line like this
//     # var = "" /*BUFD*/
//   declares a text buffer that you can later append text to. It can also be
//   passed to other templates that in turn can append text to it. In the new
//   version of Susan it should be written like this instead:
//     let &var = buffer ""
//
// - A line like this
//     ..., Text var /*BUFP*/, ...
//   declares that a template takes a text buffer as input parameter. In the
//   new version of Susan it should be written like this instead:
//     ..., Text &var, ...
//
// - A line like this:
//     ..., var /*BUFC*/, ...
//   passes a text buffer to a template. In the new version of Susan it should
//   be written like this instead:
//     ..., &var, ...
//
// - Style guidelines:
//
//   - Try (hard) to limit each row to 80 characters
//
//   - Code for a template should be indented with 2 spaces
//
//     - Exception to this rule is if you have only a single case, then that
//       single case can be written using no indentation
//
//       This single case can be seen as a clarification of the input to the
//       template
//
//   - Code after a case should be indented with 2 spaces if not written on the
//     same line

spackage SimCodeC

typeview "SimCodeTV.mo"

template translateModel(SimCode simCode) 
 "Generates C code and Makefile for compiling and running a simulation of a
  Modelica model."
::=
match simCode
case SIMCODE(__) then
  let()= textFile(simulationFile(simCode), '<%fileNamePrefix%>.cpp')
  let()= textFile(simulationFunctionsFile(functions), '<%fileNamePrefix%>_functions.cpp')
  let()= textFile(simulationMakefile(simCode), '<%fileNamePrefix%>.makefile')
  if simulationSettingsOpt then //tests the Option<> for SOME()
     let()= textFile(simulationInitFile(simCode), '<%fileNamePrefix%>_init.txt')
     "" //empty result for true case 
  //else "" //the else is automatically empty, too
  //this top-level template always returns an empty result 
  //since generated texts are written to files directly
end translateModel;


template translateFunctions(FunctionCode functionCode)
 "Generates C code and Makefile for compiling and calling Modelica and
  MetaModelica functions." 
::=
match functionCode
case FUNCTIONCODE(__) then
  let filePrefix = name
  let()= textFile(functionsFile(functions, extraRecordDecls), '<%filePrefix%>.c')
  let()= textFile(functionsMakefile(functionCode), '<%filePrefix%>.makefile')
  "" // Return empty result since result written to files directly
end translateFunctions;


template simulationFile(SimCode simCode)
 "Generates code for main C file for simulation target."
::=
match simCode
case SIMCODE(__) then
  <<
  <%simulationFileHeader(simCode)%>
  
  <%globalData(modelInfo)%>
  
  <%functionGetName(modelInfo)%>
  
  <%functionDivisionError()%>
  
  <%functionSetLocalData()%>
  
  <%functionInitializeDataStruc()%>

  <%functionCallExternalObjectConstructors(extObjInfo)%>
  
  <%functionDeInitializeDataStruc(extObjInfo)%>
  
  <%functionExtraResiduals(allEquations)%>
  
  <%functionDaeOutput(nonStateContEquations, removedEquations,
                     algorithmAndEquationAsserts)%>
  
  <%functionDaeOutput2(nonStateDiscEquations, removedEquations)%>
  
  <%functionInput(modelInfo)%>
  
  <%functionOutput(modelInfo)%>
  
  <%functionDaeRes()%>
  
  <%functionZeroCrossing(zeroCrossings)%>
  
  <%functionHandleZeroCrossing(zeroCrossingsNeedSave)%>
  
  <%functionInitSample(zeroCrossings)%>

  <%functionUpdateDependents(allEquations, helpVarInfo)%>
  
  <%functionUpdateDepend(allEquationsPlusWhen, whenClauses, helpVarInfo)%>
  
  <%functionUpdateHelpVars(helpVarInfo)%>
  
  <%functionOnlyZeroCrossing(zeroCrossings)%>
  
  <%functionCheckForDiscreteChanges(discreteModelVars)%>
  
  <%functionStoreDelayed(delayedExps)%>
  
  <%functionWhen(whenClauses)%>
  
  <%functionOde(stateContEquations)%>
  
  <%functionInitial(initialEquations)%>
  
  <%functionInitialResidual(residualEquations)%>
  
  <%functionBoundParameters(parameterEquations)%>
  
  <%functionCheckForDiscreteVarChanges(helpVarInfo, discreteModelVars)%>
  
  
  >>
end simulationFile;


template simulationFileHeader(SimCode simCode)
 "Generates header part of simulation file."
::=
match simCode
case SIMCODE(modelInfo=MODELINFO(__), extObjInfo=EXTOBJINFO(__)) then
  <<
  // Simulation code for <%dotPath(modelInfo.name)%> generated by the OpenModelica Compiler.
  
  #include "modelica.h"
  #include "assert.h"
  #include "string.h"
  #include "simulation_runtime.h"
  
  #if defined(_MSC_VER) && !defined(_SIMULATION_RUNTIME_H)
    #define DLLExport   __declspec( dllexport )
  #else 
    #define DLLExport /* nothing */
  #endif 
  
  #include "<%fileNamePrefix%>_functions.cpp"
  
  extern "C" {
  <%extObjInfo.includes |> include => include ;separator="\n"%>
  }
  >>
end simulationFileHeader;


template globalData(ModelInfo modelInfo)
 "Generates global data in simulation file."
::=
match modelInfo
case MODELINFO(varInfo=VARINFO(__), vars=SIMVARS(__)) then
  <<
  #define NHELP <%varInfo.numHelpVars%>
  #define NG <%varInfo.numZeroCrossings%> // number of zero crossings
  #define NG_SAM <%varInfo.numTimeEvents%> // number of zero crossings that are samples
  #define NX <%varInfo.numStateVars%>
  #define NY <%varInfo.numAlgVars%>
  #define NP <%varInfo.numParams%> // number of parameters
  #define NO <%varInfo.numOutVars%> // number of outputvar on topmodel
  #define NI <%varInfo.numInVars%> // number of inputvar on topmodel
  #define NR <%varInfo.numResiduals%> // number of residuals for initialialization function
  #define NEXT <%varInfo.numExternalObjects%> // number of external objects
  #define MAXORD 5
  #define NYSTR <%varInfo.numStringAlgVars%> // number of alg. string variables
  #define NPSTR <%varInfo.numStringParamVars%> // number of alg. string variables
  #define NYINT <%varInfo.numIntAlgVars%> // number of alg. int variables
  #define NPINT <%varInfo.numIntParams%> // number of alg. int variables
  #define NYBOOL <%varInfo.numBoolAlgVars%> // number of alg. bool variables
  #define NPBOOL <%varInfo.numBoolParams%> // number of alg. bool variables
  
  static DATA* localData = 0;
  #define time localData->timeValue
  #define $P$old$Ptime localData->oldTime
  #define $P$current_step_size globalData->current_stepsize

  extern "C" { // adrpo: this is needed for Visual C++ compilation to work!
    const char *model_name="<%dotPath(name)%>";
    const char *model_dir="<%directory%>";
  }
  
  // we need to access the inline define that we compiled the simulation with
  // from the simulation runtime.
  const char *_omc_force_solver=_OMC_FORCE_SOLVER;
  const int inline_work_states_ndims=_OMC_SOLVER_WORK_STATES_NDIMS;

  <%globalDataVarNamesArray("state_names", vars.stateVars)%>
  <%globalDataVarNamesArray("derivative_names", vars.derivativeVars)%>
  <%globalDataVarNamesArray("algvars_names", vars.algVars)%>
  <%globalDataVarNamesArray("input_names", vars.inputVars)%>
  <%globalDataVarNamesArray("output_names", vars.outputVars)%>
  <%globalDataVarNamesArray("param_names", vars.paramVars)%>
  <%globalDataVarNamesArray("int_alg_names", vars.intAlgVars)%>
  <%globalDataVarNamesArray("int_param_names", vars.intParamVars)%>
  <%globalDataVarNamesArray("bool_alg_names", vars.boolAlgVars)%>
  <%globalDataVarNamesArray("bool_param_names", vars.boolParamVars)%>
  <%globalDataVarNamesArray("string_alg_names", vars.stringAlgVars)%>
  <%globalDataVarNamesArray("string_param_names", vars.stringParamVars)%>
  
  <%globalDataVarCommentsArray("state_comments", vars.stateVars)%>
  <%globalDataVarCommentsArray("derivative_comments", vars.derivativeVars)%>
  <%globalDataVarCommentsArray("algvars_comments", vars.algVars)%>
  <%globalDataVarCommentsArray("input_comments", vars.inputVars)%>
  <%globalDataVarCommentsArray("output_comments", vars.outputVars)%>
  <%globalDataVarCommentsArray("param_comments", vars.paramVars)%>
  <%globalDataVarCommentsArray("int_alg_comments", vars.intAlgVars)%>
  <%globalDataVarCommentsArray("int_param_comments", vars.intParamVars)%>
  <%globalDataVarCommentsArray("bool_alg_comments", vars.boolAlgVars)%>
  <%globalDataVarCommentsArray("bool_param_comments", vars.boolParamVars)%>
  <%globalDataVarCommentsArray("string_alg_comments", vars.stringAlgVars)%>
  <%globalDataVarCommentsArray("string_param_comments", vars.stringParamVars)%>
  
  <%vars.stateVars |> var =>
    globalDataVarDefine(var, "states")
  ;separator="\n"%>
  <%vars.derivativeVars |> var =>
    globalDataVarDefine(var, "statesDerivatives")
  ;separator="\n"%>
  <%vars.algVars |> var =>
    globalDataVarDefine(var, "algebraics")
  ;separator="\n"%>
  <%vars.paramVars |> var =>
    globalDataVarDefine(var, "parameters")
  ;separator="\n"%>
  <%vars.extObjVars |> var =>
    globalDataVarDefine(var, "extObjs")
  ;separator="\n"%>
  <%vars.intAlgVars |> var =>
    globalDataVarDefine(var, "intVariables.algebraics")
  ;separator="\n"%>
  <%vars.intParamVars |> var =>
    globalDataVarDefine(var, "intVariables.parameters")
  ;separator="\n"%>
  <%vars.boolAlgVars |> var =>
    globalDataVarDefine(var, "boolVariables.algebraics")
  ;separator="\n"%>
  <%vars.boolParamVars |> var =>
    globalDataVarDefine(var, "boolVariables.parameters")
  ;separator="\n"%>  
  <%vars.stringAlgVars |> var =>
    globalDataVarDefine(var, "stringVariables.algebraics")
  ;separator="\n"%>
  <%vars.stringParamVars |> var =>
    globalDataVarDefine(var, "stringVariables.parameters")
  ;separator="\n"%>
  
  static char init_fixed[NX+NX+NY+NYINT+NYBOOL+NYSTR+NP+NPINT+NPBOOL+NPSTR] = {
    <%{(vars.stateVars |> SIMVAR(__) =>
        '<%globalDataFixedInt(isFixed)%> /* <%crefStr(name)%> */'
      ;separator=",\n"),
      (vars.derivativeVars |> SIMVAR(__) =>
        '<%globalDataFixedInt(isFixed)%> /* <%crefStr(name)%> */'
      ;separator=",\n"),
      (vars.algVars |> SIMVAR(__) =>
        '<%globalDataFixedInt(isFixed)%> /* <%crefStr(name)%> */'
      ;separator=",\n"),
      (vars.intAlgVars |> SIMVAR(__) =>
        '<%globalDataFixedInt(isFixed)%> /* <%crefStr(name)%> */'
      ;separator=",\n"),
      (vars.boolAlgVars |> SIMVAR(__) =>
        '<%globalDataFixedInt(isFixed)%> /* <%crefStr(name)%> */'
      ;separator=",\n"),        
      (vars.paramVars |> SIMVAR(__) =>
        '<%globalDataFixedInt(isFixed)%> /* <%crefStr(name)%> */'
      ;separator=",\n"),
     (vars.intParamVars |> SIMVAR(__) =>
        '<%globalDataFixedInt(isFixed)%> /* <%crefStr(name)%> */'
      ;separator=",\n"),
     (vars.boolParamVars |> SIMVAR(__) =>
        '<%globalDataFixedInt(isFixed)%> /* <%crefStr(name)%> */'
      ;separator=",\n")}
    ;separator=",\n"%>
  };
  
  char var_attr[NX+NY+NYINT+NYBOOL+NYSTR+NP+NPINT+NPBOOL+NPSTR] = {
    <%{(vars.stateVars |> SIMVAR(__) =>
        '<%globalDataAttrInt(type_)%>+<%globalDataDiscAttrInt(isDiscrete)%> /* <%crefStr(name)%> */'
      ;separator=",\n"),
      (vars.algVars |> SIMVAR(__) =>
        '<%globalDataAttrInt(type_)%>+<%globalDataDiscAttrInt(isDiscrete)%> /* <%crefStr(name)%> */'
      ;separator=",\n"),
      (vars.intAlgVars |> SIMVAR(__) =>
        '<%globalDataAttrInt(type_)%>+<%globalDataDiscAttrInt(isDiscrete)%> /* <%crefStr(name)%> */'
      ;separator=",\n"),
      (vars.boolAlgVars |> SIMVAR(__) =>
        '<%globalDataAttrInt(type_)%>+<%globalDataDiscAttrInt(isDiscrete)%> /* <%crefStr(name)%> */'
      ;separator=",\n"),
      (vars.stringAlgVars |> SIMVAR(__) =>
        '<%globalDataAttrInt(type_)%>+<%globalDataDiscAttrInt(isDiscrete)%> /* <%crefStr(name)%> */'
      ;separator=",\n"),      
      (vars.paramVars |> SIMVAR(__) =>
        '<%globalDataAttrInt(type_)%>+<%globalDataDiscAttrInt(isDiscrete)%> /* <%crefStr(name)%> */'
       ;separator=",\n"),
      (vars.intParamVars |> SIMVAR(__) =>
        '<%globalDataAttrInt(type_)%>+<%globalDataDiscAttrInt(isDiscrete)%> /* <%crefStr(name)%> */'
       ;separator=",\n"),
      (vars.boolParamVars |> SIMVAR(__) =>
        '<%globalDataAttrInt(type_)%>+<%globalDataDiscAttrInt(isDiscrete)%> /* <%crefStr(name)%> */'
       ;separator=",\n"),
      (vars.stringParamVars |> SIMVAR(__) =>
        '<%globalDataAttrInt(type_)%>+<%globalDataDiscAttrInt(isDiscrete)%> /* <%crefStr(name)%> */'
       ;separator=",\n") }
    ;separator=",\n"%>
  };
  >>
end globalData;


template globalDataVarNamesArray(String name, list<SimVar> items)
 "Generates array with variable names in global data section."
::=
  match items
  case {} then
    <<
    const char* <%name%>[1] = {""};
    >>
  case items then
    let itemsStr = (items |> SIMVAR(__) => '"<%crefStr(name)%>"' ;separator=", ")
    <<
    const char* <%name%>[<%listLength(items)%>] = {<%itemsStr%>};
    >>
end globalDataVarNamesArray;


template globalDataVarCommentsArray(String name, list<SimVar> items)
 "Generates array with variable comments in global data section."
::=
  match items
  case {} then
    <<
    const char* <%name%>[1] = {""};
    >>
  case items then
    let itemsStr = (items |> SIMVAR(__) => '"<%comment%>"' ;separator=", ")
    <<
    const char* <%name%>[<%listLength(items)%>] = {<%itemsStr%>};
    >>
end globalDataVarCommentsArray;


template globalDataVarDefine(SimVar simVar, String arrayName)
 "Generates a define statement for a varable in the global data section."
::=
  match simVar
  case SIMVAR(arrayCref=SOME(c)) then
    <<
    #define <%cref(c)%> localData-><%arrayName%>[<%index%>]
    #define <%cref(name)%> localData-><%arrayName%>[<%index%>]
    #define $P$old<%cref(name)%> localData->old_<%arrayName%>[<%index%>]
    #define $P$old2<%cref(name)%> localData->old_<%arrayName%>[<%index%>]
    >>
  case SIMVAR(__) then
    <<
    #define <%cref(name)%> localData-><%arrayName%>[<%index%>]
    #define $P$old<%cref(name)%> localData->old_<%arrayName%>[<%index%>]
    #define $P$old2<%cref(name)%> localData->old_<%arrayName%>[<%index%>]
    >>
end globalDataVarDefine;


template globalDataFixedInt(Boolean isFixed)
 "Generates integer for use in arrays in global data section."
::=
  match isFixed
  case true  then "1"
  case false then "0"
end globalDataFixedInt;


template globalDataAttrInt(DAE.ExpType type)
 "Generates integer for use in arrays in global data section."
::=
  match type
  case ET_REAL(__)   then "1"
  case ET_STRING(__) then "2"
  case ET_INT(__)    then "4"
  case ET_BOOL(__)   then "8"
end globalDataAttrInt;


template globalDataDiscAttrInt(Boolean isDiscrete)
 "Generates integer for use in arrays in global data section."
::=
  match isDiscrete
  case true  then "16"
  case false then "0"
end globalDataDiscAttrInt;


template functionGetName(ModelInfo modelInfo)
 "Generates function in simulation file."
::=
match modelInfo
case MODELINFO(vars=SIMVARS(__)) then
  <<
  const char* getName(double* ptr)
  {
    <%vars.stateVars |> SIMVAR(__) =>
      'if (&<%cref(name)%> == ptr) return state_names[<%index%>];'
    ;separator="\n"%>
    <%vars.derivativeVars |> SIMVAR(__) =>
      'if (&<%cref(name)%> == ptr) return derivative_names[<%index%>];'
    ;separator="\n"%>
    <%vars.algVars |> SIMVAR(__) =>
      'if (&<%cref(name)%> == ptr) return algvars_names[<%index%>];'
    ;separator="\n"%>
    <%vars.paramVars |> SIMVAR(__) =>
      'if (&<%cref(name)%> == ptr) return param_names[<%index%>];'
    ;separator="\n"%>
    return "";
  }
  
  const char* getName(modelica_integer* ptr)
  {
    <%vars.intAlgVars |> SIMVAR(__) =>
      'if (&<%cref(name)%> == ptr) return int_alg_names[<%index%>];'
    ;separator="\n"%>
    <%vars.intParamVars |> SIMVAR(__) =>
      'if (&<%cref(name)%> == ptr) return int_param_names[<%index%>];'
    ;separator="\n"%>
    return "";
  }
  
  const char* getName(modelica_boolean* ptr)
  {
    <%vars.boolAlgVars |> SIMVAR(__) =>
      'if (&<%cref(name)%> == ptr) return bool_alg_names[<%index%>];'
    ;separator="\n"%>
    <%vars.boolParamVars |> SIMVAR(__) =>
      'if (&<%cref(name)%> == ptr) return bool_param_names[<%index%>];'
    ;separator="\n"%>
    return "";
  }
  
  >>
end functionGetName;


template functionDivisionError()
 "Generates function in simulation file."
::=
  <<
  /* Commented out by Frenkel TUD because there is a new implementation of
     division by zero problem. */
  /*
  #define DIVISION(a,b,c) ((b != 0) ? a / b : a / division_error(b,c))
  
  int encounteredDivisionByZero = 0;
  
  double division_error(double b, const char* division_str)
  {
    if(!encounteredDivisionByZero) {
      fprintf(stderr, "ERROR: Division by zero in partial equation: %s.\n",division_str);
      encounteredDivisionByZero = 1;
    }
    return b;
  }
  */
  >>
end functionDivisionError;


template functionSetLocalData()
 "Generates function in simulation file."
::=
  <<
  void setLocalData(DATA* data)
  {
    localData = data;
  }
  >>
end functionSetLocalData;


template functionInitializeDataStruc()
 "Generates function in simulation file."
::=
  <<
  DATA* initializeDataStruc(DATA_FLAGS flags)
  {  
    DATA* returnData = (DATA*)malloc(sizeof(DATA));
  
    if(!returnData) //error check
      return 0;
  
    memset(returnData,0,sizeof(DATA));
    returnData->nStates = NX;
    returnData->nAlgebraic = NY;
    returnData->nParameters = NP;
    returnData->nInputVars = NI;
    returnData->nOutputVars = NO;
    returnData->nZeroCrossing = NG;
    returnData->nRawSamples = NG_SAM;
    returnData->nInitialResiduals = NR;
    returnData->nHelpVars = NHELP;
    returnData->stringVariables.nParameters = NPSTR;
    returnData->stringVariables.nAlgebraic = NYSTR;
    returnData->intVariables.nParameters = NPINT;
    returnData->intVariables.nAlgebraic = NYINT;
    returnData->boolVariables.nParameters = NPBOOL;
    returnData->boolVariables.nAlgebraic = NYBOOL;
  
    if(flags & STATES && returnData->nStates) {
      returnData->states = (double*) malloc(sizeof(double)*returnData->nStates);
      returnData->old_states = (double*) malloc(sizeof(double)*returnData->nStates);
      returnData->old_states2 = (double*) malloc(sizeof(double)*returnData->nStates);
      assert(returnData->states&&returnData->old_states&&returnData->old_states2);
      memset(returnData->states,0,sizeof(double)*returnData->nStates);
      memset(returnData->old_states,0,sizeof(double)*returnData->nStates);
      memset(returnData->old_states2,0,sizeof(double)*returnData->nStates);
    } else {
      returnData->states = 0;
      returnData->old_states = 0;
      returnData->old_states2 = 0;
    }
  
    if(flags & STATESDERIVATIVES && returnData->nStates) {
      returnData->statesDerivatives = (double*) malloc(sizeof(double)*returnData->nStates);
      returnData->old_statesDerivatives = (double*) malloc(sizeof(double)*returnData->nStates);
      returnData->old_statesDerivatives2 = (double*) malloc(sizeof(double)*returnData->nStates);
      assert(returnData->statesDerivatives&&returnData->old_statesDerivatives&&returnData->old_statesDerivatives2);
      memset(returnData->statesDerivatives,0,sizeof(double)*returnData->nStates);
      memset(returnData->old_statesDerivatives,0,sizeof(double)*returnData->nStates);
      memset(returnData->old_statesDerivatives2,0,sizeof(double)*returnData->nStates);
    } else {
      returnData->statesDerivatives = 0;
      returnData->old_statesDerivatives = 0;
      returnData->old_statesDerivatives2 = 0;
    }
  
    if(flags & HELPVARS && returnData->nHelpVars) {
      returnData->helpVars = (double*) malloc(sizeof(double)*returnData->nHelpVars);
      assert(returnData->helpVars);
      memset(returnData->helpVars,0,sizeof(double)*returnData->nHelpVars);
    } else {
      returnData->helpVars = 0;
    }
  
    if(flags & ALGEBRAICS && returnData->nAlgebraic) {
      returnData->algebraics = (double*) malloc(sizeof(double)*returnData->nAlgebraic);
      returnData->old_algebraics = (double*) malloc(sizeof(double)*returnData->nAlgebraic);
      returnData->old_algebraics2 = (double*) malloc(sizeof(double)*returnData->nAlgebraic);
      assert(returnData->algebraics&&returnData->old_algebraics&&returnData->old_algebraics2);
      memset(returnData->algebraics,0,sizeof(double)*returnData->nAlgebraic);
      memset(returnData->old_algebraics,0,sizeof(double)*returnData->nAlgebraic);
      memset(returnData->old_algebraics2,0,sizeof(double)*returnData->nAlgebraic);
    } else {
      returnData->algebraics = 0;
      returnData->old_algebraics = 0;
      returnData->old_algebraics2 = 0;
    }
  
    if (flags & ALGEBRAICS && returnData->stringVariables.nAlgebraic) {
      returnData->stringVariables.algebraics = (char**)malloc(sizeof(char*)*returnData->stringVariables.nAlgebraic);
      assert(returnData->stringVariables.algebraics);
      memset(returnData->stringVariables.algebraics,0,sizeof(char*)*returnData->stringVariables.nAlgebraic);
    } else {
      returnData->stringVariables.algebraics=0;
    }
    
    if (flags & ALGEBRAICS && returnData->intVariables.nAlgebraic) {
      returnData->intVariables.algebraics = (modelica_integer*)malloc(sizeof(modelica_integer)*returnData->intVariables.nAlgebraic);
      returnData->intVariables.old_algebraics = (modelica_integer*)malloc(sizeof(modelica_integer)*returnData->intVariables.nAlgebraic);
      returnData->intVariables.old_algebraics2 = (modelica_integer*)malloc(sizeof(modelica_integer)*returnData->intVariables.nAlgebraic);
      assert(returnData->intVariables.algebraics&&returnData->intVariables.old_algebraics&&returnData->intVariables.old_algebraics2);
      memset(returnData->intVariables.algebraics,0,sizeof(modelica_integer)*returnData->intVariables.nAlgebraic);
      memset(returnData->intVariables.old_algebraics,0,sizeof(modelica_integer)*returnData->intVariables.nAlgebraic);
      memset(returnData->intVariables.old_algebraics2,0,sizeof(modelica_integer)*returnData->intVariables.nAlgebraic);
    } else {
      returnData->intVariables.algebraics=0;
      returnData->intVariables.old_algebraics = 0;
      returnData->intVariables.old_algebraics2 = 0;
    }

    if (flags & ALGEBRAICS && returnData->boolVariables.nAlgebraic) {
      returnData->boolVariables.algebraics = (modelica_boolean*)malloc(sizeof(modelica_boolean)*returnData->boolVariables.nAlgebraic);
      returnData->boolVariables.old_algebraics = (signed char*)malloc(sizeof(modelica_boolean)*returnData->boolVariables.nAlgebraic);
      returnData->boolVariables.old_algebraics2 = (signed char*)malloc(sizeof(modelica_boolean)*returnData->boolVariables.nAlgebraic);
      assert(returnData->boolVariables.algebraics&&returnData->boolVariables.old_algebraics&&returnData->boolVariables.old_algebraics2);
      memset(returnData->boolVariables.algebraics,0,sizeof(modelica_boolean)*returnData->boolVariables.nAlgebraic);
      memset(returnData->boolVariables.old_algebraics,0,sizeof(modelica_boolean)*returnData->boolVariables.nAlgebraic);
      memset(returnData->boolVariables.old_algebraics2,0,sizeof(modelica_boolean)*returnData->boolVariables.nAlgebraic);
    } else {
      returnData->boolVariables.algebraics=0;
      returnData->boolVariables.old_algebraics = 0;
      returnData->boolVariables.old_algebraics2 = 0;
    }
    
    if(flags & PARAMETERS && returnData->nParameters) {
      returnData->parameters = (double*) malloc(sizeof(double)*returnData->nParameters);
      assert(returnData->parameters);
      memset(returnData->parameters,0,sizeof(double)*returnData->nParameters);
    } else {
      returnData->parameters = 0;
    }
  
    if (flags & PARAMETERS && returnData->stringVariables.nParameters) {
    	returnData->stringVariables.parameters = (char**)malloc(sizeof(char*)*returnData->stringVariables.nParameters);
        assert(returnData->stringVariables.parameters);
        memset(returnData->stringVariables.parameters,0,sizeof(char*)*returnData->stringVariables.nParameters);
    } else {
        returnData->stringVariables.parameters=0;
    }
    
    if (flags & PARAMETERS && returnData->intVariables.nParameters) {
    	returnData->intVariables.parameters = (modelica_integer*)malloc(sizeof(modelica_integer)*returnData->intVariables.nParameters);
        assert(returnData->intVariables.parameters);
        memset(returnData->intVariables.parameters,0,sizeof(modelica_integer)*returnData->intVariables.nParameters);
    } else {
        returnData->intVariables.parameters=0;
    }
    
    if (flags & PARAMETERS && returnData->boolVariables.nParameters) {
    	returnData->boolVariables.parameters = (modelica_boolean*)malloc(sizeof(modelica_boolean)*returnData->boolVariables.nParameters);
        assert(returnData->boolVariables.parameters);
        memset(returnData->boolVariables.parameters,0,sizeof(modelica_boolean)*returnData->boolVariables.nParameters);
    } else {
        returnData->boolVariables.parameters=0;
    }
    
    if(flags & OUTPUTVARS && returnData->nOutputVars) {
      returnData->outputVars = (double*) malloc(sizeof(double)*returnData->nOutputVars);
      assert(returnData->outputVars);
      memset(returnData->outputVars,0,sizeof(double)*returnData->nOutputVars);
    } else {
      returnData->outputVars = 0;
    }
  
    if(flags & INPUTVARS && returnData->nInputVars) {
      returnData->inputVars = (double*) malloc(sizeof(double)*returnData->nInputVars);
      assert(returnData->inputVars);
      memset(returnData->inputVars,0,sizeof(double)*returnData->nInputVars);
    } else {
      returnData->inputVars = 0;
    }
  
    if(flags & INITIALRESIDUALS && returnData->nInitialResiduals) {
      returnData->initialResiduals = (double*) malloc(sizeof(double)*returnData->nInitialResiduals);
      assert(returnData->initialResiduals);
      memset(returnData->initialResiduals,0,sizeof(double)*returnData->nInitialResiduals);
    } else {
      returnData->initialResiduals = 0;
    }
  
    if(flags & INITFIXED) {
      returnData->initFixed = init_fixed;
    } else {
      returnData->initFixed = 0;
    }
  
    /*   names   */
    if(flags & MODELNAME) {
      returnData->modelName = model_name;
    } else {
      returnData->modelName = 0;
    }
    
    if(flags & STATESNAMES) {
      returnData->statesNames = state_names;
    } else {
      returnData->statesNames = 0;
    }
  
    if(flags & STATESDERIVATIVESNAMES) {
      returnData->stateDerivativesNames = derivative_names;
    } else {
      returnData->stateDerivativesNames = 0;
    }
  
    if(flags & ALGEBRAICSNAMES) {
      returnData->algebraicsNames = algvars_names;
    } else {
      returnData->algebraicsNames = 0;
    }
    
    if(flags & ALGEBRAICSNAMES) {
      returnData->int_alg_names = int_alg_names;
    } else {
      returnData->int_alg_names = 0;
    }

    if(flags & ALGEBRAICSNAMES) {
      returnData->bool_alg_names = bool_alg_names;
    } else {
      returnData->bool_alg_names = 0;
    }
  
    if(flags & PARAMETERSNAMES) {
      returnData->parametersNames = param_names;
    } else {
      returnData->parametersNames = 0;
    }
    
    if(flags & PARAMETERSNAMES) {
      returnData->int_param_names = int_param_names;
    } else {
      returnData->int_param_names = 0;
    }

    if(flags & PARAMETERSNAMES) {
      returnData->bool_param_names = bool_param_names;
    } else {
      returnData->bool_param_names = 0;
    }
      
    if(flags & INPUTNAMES) {
      returnData->inputNames = input_names;
    } else {
      returnData->inputNames = 0;
    }
  
    if(flags & OUTPUTNAMES) {
      returnData->outputNames = output_names;
    } else {
      returnData->outputNames = 0;
    }
  
    /*   comments  */
    if(flags & STATESCOMMENTS) {
      returnData->statesComments = state_comments;
    } else {
      returnData->statesComments = 0;
    }
  
    if(flags & STATESDERIVATIVESCOMMENTS) {
      returnData->stateDerivativesComments = derivative_comments;
    } else {
      returnData->stateDerivativesComments = 0;
    }
  
    if(flags & ALGEBRAICSCOMMENTS) {
      returnData->algebraicsComments = algvars_comments;
    } else {
      returnData->algebraicsComments = 0;
    }

    if(flags & ALGEBRAICSCOMMENTS) {
      returnData->int_alg_comments = int_alg_comments;
    } else {
      returnData->int_alg_comments = 0;
    }

    if(flags & ALGEBRAICSCOMMENTS) {
      returnData->bool_alg_comments = bool_alg_comments;
    } else {
      returnData->bool_alg_comments = 0;
    }
  
    if(flags & PARAMETERSCOMMENTS) {
      returnData->parametersComments = param_comments;
    } else {
      returnData->parametersComments = 0;
    }
    
    if(flags & PARAMETERSCOMMENTS) {
      returnData->int_param_comments = int_param_comments;
    } else {
      returnData->int_param_comments = 0;
    }

    if(flags & PARAMETERSCOMMENTS) {
      returnData->bool_param_comments = bool_param_comments;
    } else {
      returnData->bool_param_comments = 0;
    }
  
    if(flags & INPUTCOMMENTS) {
      returnData->inputComments = input_comments;
    } else {
      returnData->inputComments = 0;
    }
  
    if(flags & OUTPUTCOMMENTS) {
      returnData->outputComments = output_comments;
    } else {
      returnData->outputComments = 0;
    }
  
    if(flags & RAWSAMPLES && returnData->nRawSamples) {
      returnData->rawSampleExps = (sample_raw_time*) malloc(sizeof(sample_raw_time)*returnData->nRawSamples);
      assert(returnData->rawSampleExps);
      memset(returnData->rawSampleExps,0,sizeof(sample_raw_time)*returnData->nRawSamples);
    } else {
      returnData->rawSampleExps = 0;
    }

    if (flags & EXTERNALVARS) {
      returnData->extObjs = (void**)malloc(sizeof(void*)*NEXT);
      if (!returnData->extObjs) {
        printf("error allocating external objects\n");
        exit(-2);
      }
      memset(returnData->extObjs,0,sizeof(void*)*NEXT);
    }
    return returnData;
  }
  
  >>
end functionInitializeDataStruc;

template functionCallExternalObjectConstructors(ExtObjInfo extObjInfo)
 "Generates function in simulation file."
::=
match extObjInfo
case EXTOBJINFO(__) then
  let &varDecls = buffer "" /*BUFD*/
  let &preExp = buffer "" /*BUFD*/
  let ctorCalls = (constructors |> (var, fnName, args) =>
      let argsStr = (args |> arg =>
          daeExp(arg, contextOther, &preExp /*BUFC*/, &varDecls /*BUFC*/)
        ;separator=", ")
      '<%cref(var)%> = <%fnName%>(<%argsStr%>);'
    ;separator="\n")
  <<
  /* Has to be performed after _init.txt file has been read */
  void callExternalObjectConstructors(DATA* localData) {
    <%varDecls%>
    <%preExp%>
    <%ctorCalls%>
    <%aliases |> (var1, var2) => '<%cref(var1)%> = <%cref(var2)%>;' ;separator="\n"%>
  }

  >>
end functionCallExternalObjectConstructors;


template functionDeInitializeDataStruc(ExtObjInfo extObjInfo)
 "Generates function in simulation file."
::=
match extObjInfo
case EXTOBJINFO(__) then
  <<
  void deInitializeDataStruc(DATA* data, DATA_FLAGS flags)
  {
    if(!data)
      return;
  
    if(flags & STATES && data->states) {
      free(data->states);
      data->states = 0;
    }
  
    if(flags & STATES && data->old_states) {
      free(data->old_states);
      data->old_states = 0;
    }

    if(flags & STATES && data->old_states2) {
      free(data->old_states2);
      data->old_states2 = 0;
    }

    if(flags & STATESDERIVATIVES && data->statesDerivatives) {
      free(data->statesDerivatives);
      data->statesDerivatives = 0;
    }
  
    if(flags & STATESDERIVATIVES && data->old_statesDerivatives) {
      free(data->old_statesDerivatives);
      data->old_statesDerivatives = 0;
    }
  
    if(flags & STATESDERIVATIVES && data->old_statesDerivatives2) {
      free(data->old_statesDerivatives2);
      data->old_statesDerivatives2 = 0;
    }
  
    if(flags & ALGEBRAICS && data->algebraics) {
      free(data->algebraics);
      data->algebraics = 0;
    }
  
    if(flags & ALGEBRAICS && data->old_algebraics) {
      free(data->old_algebraics);
      data->old_algebraics = 0;
    }
  
    if(flags & ALGEBRAICS && data->old_algebraics2) {
      free(data->old_algebraics2);
      data->old_algebraics2 = 0;
    }
  
    if(flags & PARAMETERS && data->parameters) {
      free(data->parameters);
      data->parameters = 0;
    }
  
    if(flags & OUTPUTVARS && data->inputVars) {
      free(data->inputVars);
      data->inputVars = 0;
    }
  
    if(flags & INPUTVARS && data->outputVars) {
      free(data->outputVars);
      data->outputVars = 0;
    }
    
    if(flags & INITIALRESIDUALS && data->initialResiduals){
      free(data->initialResiduals);
      data->initialResiduals = 0;
    }
    if (flags & EXTERNALVARS && data->extObjs) {
      <%destructors |> (fnName, var) => '<%fnName%>(<%cref(var)%>);' ;separator="\n"%>
      free(data->extObjs);
      data->extObjs = 0;
    }
    if(flags & RAWSAMPLES && data->rawSampleExps) {
      free(data->rawSampleExps);
      data->rawSampleExps = 0;
    }
    if(flags & RAWSAMPLES && data->sampleTimes) {
      free(data->sampleTimes);
      data->sampleTimes = 0;
    }
  }
  >>
end functionDeInitializeDataStruc;


template functionDaeOutput(list<SimEqSystem> nonStateContEquations,
                  list<SimEqSystem> removedEquations,
                  list<DAE.Statement> algorithmAndEquationAsserts)
 "Generates function in simulation file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let nonStateContPart = (nonStateContEquations |> eq =>
      equation_(eq, contextSimulationNonDiscrete, &varDecls /*BUFC*/)
    ;separator="\n")
  let algAndEqAssertsPart = (algorithmAndEquationAsserts |> stmt =>
      algStatement(stmt, contextSimulationNonDiscrete, &varDecls /*BUFC*/)
    ;separator="\n")
  let removedPart = (removedEquations |> eq =>
      equation_(eq, contextSimulationNonDiscrete, &varDecls /*BUFC*/)
    ;separator="\n")
  <<
  /* for continuous time variables */
  int functionDAE_output()
  {
    state mem_state;
    <%varDecls%>
  
    mem_state = get_memory_state();
    <%nonStateContPart%>
    <%algAndEqAssertsPart%>
    <%removedPart%>
    restore_memory_state(mem_state);
  
    return 0;
  }
  >>
end functionDaeOutput;


template functionDaeOutput2(list<SimEqSystem> nonStateDiscEquations,
                   list<SimEqSystem> removedEquations)
 "Generates function in simulation file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let nonSateDiscPart = (nonStateDiscEquations |> eq =>
      equation_(eq, contextSimulationDiscrete, &varDecls /*BUFC*/)
    ;separator="\n")
  let removedPart = (removedEquations |> eq =>
      equation_(eq, contextSimulationDiscrete, &varDecls /*BUFC*/)
    ;separator="\n")
  <<
  /* for discrete time variables */
  int functionDAE_output2()
  {
    state mem_state;
    <%varDecls%>
  
    mem_state = get_memory_state();
    <%nonSateDiscPart%>
    <%removedPart%>
    restore_memory_state(mem_state);
  
    return 0;
  }
  >>
end functionDaeOutput2;


template functionInput(ModelInfo modelInfo)
 "Generates function in simulation file."
::=
match modelInfo
case MODELINFO(vars=SIMVARS(__)) then
  <<
  int input_function()
  {
    <%vars.inputVars |> SIMVAR(__) indexedby i0 =>
      '<%cref(name)%> = localData->inputVars[<%i0%>];'
    ;separator="\n"%>
    return 0;
  }
  >>
end functionInput;


template functionOutput(ModelInfo modelInfo)
 "Generates function in simulation file."
::=
match modelInfo
case MODELINFO(vars=SIMVARS(__)) then
  <<
  int output_function()
  {
    <%vars.outputVars |> SIMVAR(__) indexedby i0 =>
      'localData->outputVars[<%i0%>] = <%cref(name)%>;'
    ;separator="\n"%>
    return 0;
  }
  >>
end functionOutput;


template functionDaeRes()
  "Generates function in simulation file."
::=
  <<
  int functionDAE_res(double *t, double *x, double *xd, double *delta,
                      fortran_integer *ires, double *rpar, fortran_integer *ipar)
  {
    int i;
    double temp_xd[NX];
    double temp_alg[NY];
    double* statesBackup;
    double* statesDerivativesBackup;
    double* algebraicsBackup;
    double timeBackup;
  
    statesBackup = localData->states;
    statesDerivativesBackup = localData->statesDerivatives;
    algebraicsBackup = localData->algebraics;
    timeBackup = localData->timeValue;
    localData->states = x;
    
    localData->statesDerivatives = temp_xd;
    localData->algebraics = temp_alg;
    localData->timeValue = *t;
  
    memcpy(localData->statesDerivatives, statesDerivativesBackup, localData->nStates*sizeof(double));
    memcpy(localData->algebraics, algebraicsBackup, localData->nAlgebraic*sizeof(double));
  
    functionODE();
  
    /* get the difference between the temp_xd(=localData->statesDerivatives)
       and xd(=statesDerivativesBackup) */
    for (i=0; i < localData->nStates; i++) {
      delta[i] = localData->statesDerivatives[i] - statesDerivativesBackup[i];
    }
  
    localData->states = statesBackup;
    localData->statesDerivatives = statesDerivativesBackup;
    localData->algebraics = algebraicsBackup;
    localData->timeValue = timeBackup;
  
    if (modelErrorCode) {
      if (ires) {
        *ires = -1;
      }
      modelErrorCode =0;
    }
  
    return 0;
  }
  >>
end functionDaeRes;


template functionZeroCrossing(list<ZeroCrossing> zeroCrossings)
  "Generates function in simulation file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let zeroCrossingsCode = zeroCrossingsTpl(zeroCrossings, &varDecls /*BUFC*/)
  <<
  int function_zeroCrossing(fortran_integer *neqm, double *t, double *x, fortran_integer *ng,
                            double *gout, double *rpar, fortran_integer* ipar)
  {
    double timeBackup;
    state mem_state;
  
    mem_state = get_memory_state();
  
    timeBackup = localData->timeValue;
    localData->timeValue = *t;
    <%varDecls%>
  
    functionODE();
    functionDAE_output();
  
    <%zeroCrossingsCode%>
  
    restore_memory_state(mem_state);
    localData->timeValue = timeBackup;
  
    return 0;
  }
  >>
end functionZeroCrossing;


template functionHandleZeroCrossing(list<list<SimVar>> zeroCrossingsNeedSave)
  "Generates function in simulation file."
::=
  <<
  /* This function should only save in cases. The rest is done in
     function_updateDependents. */
  int handleZeroCrossing(long index)
  {
    state mem_state;
  
    mem_state = get_memory_state();
  
    switch(index) {
      <%zeroCrossingsNeedSave |> vars indexedby i0 =>
        <<
        case <%i0%>:
          <%vars |> SIMVAR(__) => 'save(<%cref(name)%>);' ;separator="\n"%>
          break;
        >>
      ;separator="\n"%>
      default:
        break;
    }
  
    restore_memory_state(mem_state);
  
    return 0;
  }
  >>
end functionHandleZeroCrossing;

template functionInitSample(list<ZeroCrossing> zeroCrossings)
  "Generates function initSample() in simulation file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let timeEventCode = timeEventsTpl(zeroCrossings, &varDecls /*BUFC*/)
  <<
  /* Initializes the raw time events of the simulation using the now
     calcualted parameters. */
  void function_sampleInit()
  {
    int i = 0; // Current index
    <%timeEventCode%>
  }
  >>
end functionInitSample;

template functionUpdateDependents(list<SimEqSystem> allEquations,
                                  list<HelpVarInfo> helpVarInfo)
 "Generates function in simulation file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let eqs = (allEquations |> eq =>
      equation_(eq, contextSimulationDiscrete, &varDecls /*BUFC*/)
    ;separator="\n")
  let hvars = (helpVarInfo |> (hindex, exp, _) =>
      let &preExp = buffer "" /*BUFD*/
      let expPart = daeExp(exp, contextSimulationDiscrete, &preExp /*BUFC*/,
                         &varDecls /*BUFC*/)
      '<%preExp%>localData->helpVars[<%hindex%>] = <%expPart%>;'
    ;separator="\n")
  <<
  int function_updateDependents()
  {
    state mem_state;
    <%varDecls%>
  
    inUpdate=initial()?0:1;
  
    mem_state = get_memory_state();
    <%eqs%>
    <%hvars%>
    restore_memory_state(mem_state);
  
    inUpdate=0;
  
    return 0;
  }
  >>
end functionUpdateDependents;


template functionUpdateDepend(	list<SimEqSystem> allEquationsPlusWhen, 
								list<SimWhenClause> whenClauses,
								list<HelpVarInfo> helpVarInfo)
  "Generates function in simulation file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let eqs = (allEquationsPlusWhen |> eq =>
      equation_(eq, contextSimulationDiscrete, &varDecls /*BUFC*/)
    ;separator="\n")
    
  let reinit = (whenClauses |> when indexedby i0 =>
  		genreinits(when, &varDecls,i0)
  	;separator="\n")
  <<
  int function_updateDepend(int &needToIterate)
  {
    state mem_state;
    <%varDecls%>
    needToIterate = 0;
    inUpdate=initial()?0:1;
  
    mem_state = get_memory_state();
    <%eqs%>
    <%reinit%>
    restore_memory_state(mem_state);
  
    inUpdate=0;
  
    return 0;
  }
  >>
end functionUpdateDepend;


template functionOnlyZeroCrossing(list<ZeroCrossing> zeroCrossings)
  "Generates function in simulation file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let zeroCrossingsCode = zeroCrossingsTpl(zeroCrossings, &varDecls /*BUFC*/)
  <<
  int function_onlyZeroCrossings(double *gout,double *t)
  {
    state mem_state;
    <%varDecls%>
  
    mem_state = get_memory_state();
    <%zeroCrossingsCode%>
    restore_memory_state(mem_state);
  
    return 0;
  }
  >>
end functionOnlyZeroCrossing;

template functionUpdateHelpVars(list<HelpVarInfo> helpVarInfo)
 "Generates function in simulation file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let hvars = (helpVarInfo |> (hindex, exp, _) =>
      let &preExp = buffer "" /*BUFD*/
      let expPart = daeExp(exp, contextSimulationDiscrete, &preExp /*BUFC*/,
                         &varDecls /*BUFC*/)
      '<%preExp%>localData->helpVars[<%hindex%>] = <%expPart%>;'
    ;separator="\n")
  <<
  int function_updatehelpvars()
  {
    state mem_state;
    <%varDecls%>
  
    mem_state = get_memory_state();
    <%hvars%>
    restore_memory_state(mem_state);
  
    return 0;
  }
  >>
end functionUpdateHelpVars;


template functionCheckForDiscreteChanges(list<ComponentRef> discreteModelVars)
  "Generates function in simulation file."
::=
  <<
  int checkForDiscreteChanges()
  {
    int needToIterate = 0;
  
    <%discreteModelVars |> var =>
      'if (change(<%cref(var)%>)) { needToIterate=1; }'
    ;separator="\n"%>
    
    return needToIterate;
  }
  >>
end functionCheckForDiscreteChanges;


template functionStoreDelayed(DelayedExpression delayed)
  "Generates function in simulation file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let storePart = (match delayed case DELAYED_EXPRESSIONS(__) then (delayedExps |> (id, e) =>
      let &preExp = buffer "" /*BUFD*/
      let eRes = daeExp(e, contextSimulationNonDiscrete,
                      &preExp /*BUFC*/, &varDecls /*BUFC*/)
      <<
      <%preExp%>
      storeDelayedExpression(<%id%>, <%eRes%>);
      >>
    ))
  <<
  extern int const numDelayExpressionIndex = <%match delayed case DELAYED_EXPRESSIONS(__) then maxDelayedIndex%>;
  int function_storeDelayed()
  {
    state mem_state;
    <%varDecls%>

    mem_state = get_memory_state();
    <%storePart%>
    restore_memory_state(mem_state);

    return 0;
  }
  >>
end functionStoreDelayed;


template functionWhen(list<SimWhenClause> whenClauses)
  "Generates function in simulation file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let cases = (whenClauses |> SIM_WHEN_CLAUSE(__) indexedby i0 =>
      <<
      case <%i0%>:
        <%functionWhenCaseEquation(whenEq, &varDecls /*BUFC*/)%>
        <%reinits |> reinit =>
          let &preExp = buffer "" /*BUFD*/
          let body = functionWhenReinitStatement(reinit, &preExp /*BUFC*/,
                                               &varDecls /*BUFC*/)
          '<%preExp%><%\n%><%body%>'
        ;separator="\n"%>
        break;<%\n%>
      >>
    )
  <<
  int function_when(int i)
  {
    state mem_state;
    <%varDecls%>
  
    mem_state = get_memory_state();
  
    switch(i) {
      <%cases%>
      default:
        break;
    }
  
    restore_memory_state(mem_state);
  
    return 0;
  }
  >>
end functionWhen;


template functionWhenCaseEquation(Option<WhenEquation> when, Text &varDecls /*BUFP*/)
  "Generates content of case-clause for a when equation in function_when."
::=
match when
case SOME(weq as WHEN_EQ(__)) then
  let &preExp = buffer "" /*BUFD*/
  let expPart = daeExp(weq.right, contextSimulationDiscrete,
                     &preExp /*BUFC*/, &varDecls /*BUFC*/)
  <<
  save(<%cref(weq.left)%>);
  
  <%preExp%>
  <%cref(weq.left)%> = <%expPart%>;
  >>
end functionWhenCaseEquation;


template functionWhenReinitStatement(ReinitStatement reinit, Text &preExp /*BUFP*/,
                            Text &varDecls /*BUFP*/)
 "Generates re-init statement for when equation."
::=
match reinit
case REINIT(__) then
  let val = daeExp(value, contextSimulationDiscrete,
                 &preExp /*BUFC*/, &varDecls /*BUFC*/)
  <<
  <%cref(stateVar)%> = <%val%>;
  >>
end functionWhenReinitStatement;


template genreinits(SimWhenClause whenClauses, Text &varDecls, Integer int)
" Generates reinit statemeant"
::=

match whenClauses
case SIM_WHEN_CLAUSE(__) then
  let &preExp = buffer "" /*BUFD*/
  let &helpInits = buffer "" /*BUFD*/
  let helpIf = (conditions |> (e, hidx) =>
      let helpInit = daeExp(e, contextSimulationDiscrete, &preExp /*BUFC*/, &varDecls /*BUFC*/)
      let &helpInits += 'localData->helpVars[<%hidx%>] = <%helpInit%>;'
      'edge(localData->helpVars[<%hidx%>])'
    ;separator=" || ")	
  let ifthen = functionWhenReinitStatementThen(reinits, &preExp /*BUFP*/,
                            &varDecls /*BUFP*/)                     
/*let ifelse = functionWhenReinitStatementElse(reinits, &preExp /*BUFP*/,
  							&varDecls /*BUFP*/) 
  let hvars = (conditions |> (exp, hindex) =>
  let expPart = daeExp(exp, contextSimulationDiscrete, &preExp /*BUFC*/,
                        &varDecls /*BUFC*/)
  '<%preExp%>localData->helpVars[<%hindex%>] = <%expPart%>;'
	)
*/

if reinits then	
<<

  //For whenclause index: <%int%>
  <%preExp%>
  <%helpInits%>
  if (<%helpIf%>) { 
    <%ifthen%>
     needToIterate = 1;
  }
>>
end genreinits;

      /*
      let &preExp2 = buffer "" /*BUFD*/
  let reint = ( reinits |> reinit =>  
  let expL = functionWhenReinitStatementCond(reinit, helpif, &preExp2, &varDecls)
  '<%preExp2%>\n<%expL%>;')
      	//if reinits then
	  //let &varDecls = buffer "" /*BUFD*/
      let helpif = 'edge(localData->helpVars[<%hindex%>]'
      let &preExp2 = buffer "" /*BUFD*/
      let reint = ( reinits |> reinit =>  
      let expL = functionWhenReinitStatementCond(reinit, helpif, &preExp2, &varDecls)

      '<%preExp%>\n<%expL%>'
      ;separator="\n")
    >>*/

template functionWhenReinitStatementThen(list<ReinitStatement> reinits, Text &preExp /*BUFP*/,
                            Text &varDecls /*BUFP*/)
 "Generates re-init statement for when equation."
::=
  let body = (reinits |> reinit =>
  	match reinit
  	case REINIT(__) then 
  		let val = daeExp(value, contextSimulationDiscrete,
        	         &preExp /*BUFC*/, &varDecls /*BUFC*/)
  		'<%cref(stateVar)%> = <%val%>;';separator="\n"
  	)
  <<
   <%body%>	
  >>
end functionWhenReinitStatementThen;


template functionWhenReinitStatementElse(list<ReinitStatement> reinits, Text &preExp /*BUFP*/,
                            Text &varDecls /*BUFP*/)
 "Generates re-init statement for when equation."
::=
  let body = (reinits |> reinit =>
  	match reinit
  	case REINIT(__) then 
  		let val = daeExp(value, contextSimulationDiscrete,
        	         &preExp /*BUFC*/, &varDecls /*BUFC*/)
  		'<%cref(stateVar)%> = pre(<%cref(stateVar)%>);';separator="\n"
  	)
  <<
   <%body%>	
  >>
end functionWhenReinitStatementElse;


template functionOde(list<SimEqSystem> stateContEquations)
 "Generates function in simulation file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let stateContPart = (stateContEquations |> eq =>
      equation_(eq, contextSimulationNonDiscrete, &varDecls /*BUFC*/)
    ;separator="\n")
  let &varDecls2 = buffer "" /*BUFD*/
  let stateContPartInline = (stateContEquations |> eq =>
      equation_(eq, contextInlineSolver, &varDecls2 /*BUFC*/)
    ;separator="\n")
  <<
  int functionODE()
  {
    state mem_state;
    <%varDecls%>
  
    mem_state = get_memory_state();
    <%stateContPart%>
    restore_memory_state(mem_state);
  
    return 0;
  }

  #if defined(_OMC_ENABLE_INLINE)
  int functionODE_inline()
  {
    state mem_state;
    <%varDecls2%>
  
    mem_state = get_memory_state();
    begin_inline();
    <%stateContPartInline%>
    end_inline();
    restore_memory_state(mem_state);
  
    return 0;
  }
  #else
  int functionODE_inline()
  {
    return 0;
  }
  #endif
  >>
end functionOde;


template functionInitial(list<SimEqSystem> initialEquations)
 "Generates function in simulation file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let eqPart = (initialEquations |> eq as SES_SIMPLE_ASSIGN(__) =>
      equation_(eq, contextOther, &varDecls /*BUFC*/)
    ;separator="\n")
  <<
  int initial_function()
  {
    <%varDecls%>
  
    <%eqPart%>
  
    <%initialEquations |> SES_SIMPLE_ASSIGN(__) =>
      'if (sim_verbose) { printf("Setting variable start value: %s(start=%f)\n", "<%cref(cref)%>", <%cref(cref)%>); }'
    ;separator="\n"%>
  
    return 0;
  }
  >>
end functionInitial;


template functionInitialResidual(list<SimEqSystem> residualEquations)
 "Generates function in simulation file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let body = (residualEquations |> SES_RESIDUAL(__) =>
      match exp 
      case DAE.SCONST(__) then
        'localData->initialResiduals[i++] = 0;'
      else
        let &preExp = buffer "" /*BUFD*/
        let expPart = daeExp(exp, contextOther, &preExp /*BUFC*/,
                           &varDecls /*BUFC*/)
        '<%preExp%>localData->initialResiduals[i++] = <%expPart%>;'
    ;separator="\n")
  <<
  int initial_residual()
  {
    int i = 0;
    state mem_state;
    <%varDecls%>
  
    mem_state = get_memory_state();
    <%body%>
    restore_memory_state(mem_state);
  
    return 0;
  }
  >>
end functionInitialResidual;


template functionExtraResiduals(list<SimEqSystem> allEquations)
 "Generates functions in simulation file."
::=
  (allEquations |> eq as SES_NONLINEAR(__) =>
     let &varDecls = buffer "" /*BUFD*/
     let prebody = (eq.eqs |> eq2 as SES_SIMPLE_ASSIGN(__) =>
         equation_(eq2, contextOther, &varDecls /*BUFC*/)
       ;separator="\n")   
     let body = (eq.eqs |> eq2 as SES_RESIDUAL(__) indexedby i0 =>
         let &preExp = buffer "" /*BUFD*/
         let expPart = daeExp(eq2.exp, contextSimulationDiscrete,
                            &preExp /*BUFC*/, &varDecls /*BUFC*/)
         '<%preExp%>res[<%i0%>] = <%expPart%>;'
       ;separator="\n")
     <<
     void residualFunc<%index%>(int *n, double* xloc, double* res, int* iflag)
     {
       state mem_state;
       <%varDecls%>
       mem_state = get_memory_state();
       <%prebody%>
       <%body%>
       restore_memory_state(mem_state);
     }
     >>
   ;separator="\n\n")
end functionExtraResiduals;


template functionBoundParameters(list<SimEqSystem> parameterEquations)
 "Generates function in simulation file."
::=
  let &varDecls = buffer "" /*BUFD*/
  let body = (parameterEquations |> eq as SES_SIMPLE_ASSIGN(__) =>
      equation_(eq, contextOther, &varDecls /*BUFC*/)
    ;separator="\n")
  let divbody = (parameterEquations |> eq as SES_ALGORITHM(__) =>
      equation_(eq, contextOther, &varDecls /*BUFC*/)
    ;separator="\n")    
  <<
  int bound_parameters()
  {
    state mem_state;
    <%varDecls%>
  
    mem_state = get_memory_state();
    <%body%>
    <%divbody%>
    restore_memory_state(mem_state);
  
    return 0;
  }
  >>
end functionBoundParameters;

//TODO: Is the -1 windex check really correct? It seems to work.
template functionCheckForDiscreteVarChanges(list<HelpVarInfo> helpVarInfo,
                                            list<ComponentRef> discreteModelVars)
 "Generates function in simulation file."
::=
  <<
  int checkForDiscreteVarChanges()
  {
    int needToIterate = 0;
  
    <%helpVarInfo |> (hindex, exp, windex) =>
      match windex //if windex is not -1 then
      case -1 then ""
      else
        'if (edge(localData->helpVars[<%hindex%>])) AddEvent(<%windex%> + localData->nZeroCrossing);'
    ;separator="\n"%>
  
    <%discreteModelVars |> var =>
      'if (change(<%cref(var)%>)) { needToIterate=1; }'
    ;separator="\n"%>
    
    for (long i = 0; i < localData->nHelpVars; i++) {
      if (change(localData->helpVars[i])) {
        needToIterate=1;
      }
    }
  
    return needToIterate;
  }
  >>
end functionCheckForDiscreteVarChanges;


template zeroCrossingsTpl(list<ZeroCrossing> zeroCrossings, Text &varDecls /*BUFP*/)
 "Generates code for zero crossings."
::=

  (zeroCrossings |> ZERO_CROSSING(__) indexedby i0 =>
    zeroCrossingTpl(i0, relation_, &varDecls /*BUFC*/)
  ;separator="\n")
end zeroCrossingsTpl;


template zeroCrossingTpl(Integer index, Exp relation, Text &varDecls /*BUFP*/)
 "Generates code for a zero crossing."
::=
  match relation
  case RELATION(__) then
    let &preExp = buffer "" /*BUFD*/
    let e1 = daeExp(exp1, contextOther, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let op = zeroCrossingOpFunc(operator)
    let e2 = daeExp(exp2, contextOther, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    <<
    <%preExp%>
    ZEROCROSSING(<%index%>, <%op%>(<%e1%>, <%e2%>));
    >>
  case CALL(path=IDENT(name="sample"), expLst={start, interval}) then
    let &preExp = buffer "" /*BUFD*/
    let e1 = daeExp(start, contextOther, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let e2 = daeExp(interval, contextOther, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    <<
    <%preExp%>
    ZEROCROSSING(<%index%>,Sample(*t,<%e1%>,<%e2%>));
    >>
  else
    <<
    ZERO CROSSING ERROR
    >>
end zeroCrossingTpl;


template timeEventsTpl(list<ZeroCrossing> zeroCrossings, Text &varDecls /*BUFP*/)
 "Generates code for zero crossings."
::=
  (zeroCrossings |> ZERO_CROSSING(__) indexedby i0 =>
    timeEventTpl(i0, relation_, &varDecls /*BUFC*/)
  ;separator="\n")
end timeEventsTpl;


template timeEventTpl(Integer index, Exp relation, Text &varDecls /*BUFP*/)
 "Generates code for a zero crossing."
::=
  match relation
  case RELATION(__) then
    <<
    /* <%index%> Not a time event */
    >>
  case CALL(path=IDENT(name="sample"), expLst={start, interval}) then
    let &preExp = buffer "" /*BUFD*/
    let e1 = daeExp(start, contextOther, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let e2 = daeExp(interval, contextOther, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    <<
    <%preExp%>
    localData->rawSampleExps[i].start = <%e1%>;
    localData->rawSampleExps[i].interval = <%e2%>;
    localData->rawSampleExps[i++].zc_index = <%index%>;
    >>
  else
    <<
    ZERO CROSSING ERROR
    >>
end timeEventTpl;

template zeroCrossingOpFunc(Operator op)
 "Generates zero crossing function name for operator."
::=
  match op
  case LESS(__)      then "Less"
  case GREATER(__)   then "Greater"
  case LESSEQ(__)    then "LessEq"
  case GREATEREQ(__) then "GreaterEq"
end zeroCrossingOpFunc;


template equation_(SimEqSystem eq, Context context, Text &varDecls /*BUFP*/)
 "Generates an equation.
  This template should not be used for a SES_RESIDUAL.
  Residual equations are handled differently."
::=
  match eq
  case e as SES_SIMPLE_ASSIGN(__)
    then equationSimpleAssign(e, context, &varDecls /*BUFC*/)
  case e as SES_ARRAY_CALL_ASSIGN(__)
    then equationArrayCallAssign(e, context, &varDecls /*BUFC*/)
  case e as SES_ALGORITHM(__)
    then equationAlgorithm(e, context, &varDecls /*BUFC*/)
  case e as SES_LINEAR(__)
    then equationLinear(e, context, &varDecls /*BUFC*/)
  case e as SES_MIXED(__)
    then equationMixed(e, context, &varDecls /*BUFC*/)
  case e as SES_NONLINEAR(__)
    then equationNonlinear(e, context, &varDecls /*BUFC*/)
  case e as SES_WHEN(__)
    then equationWhen(e, context, &varDecls /*BUFC*/)
  else
    "NOT IMPLEMENTED EQUATION"
end equation_;


template inlineArray(Context context, String arr, ComponentRef c)
::= match context case INLINE_CONTEXT(__) then match c
case CREF_QUAL(ident = "$DER") then <<

inline_integrate_array(size_of_dimension_real_array(<%arr%>,1),<%cref(c)%>);
>>
end inlineArray;


template inlineVars(Context context, list<SimVar> simvars)
::= match context case INLINE_CONTEXT(__) then match simvars
case {} then ''
else <<

<%simvars |> var => match var case SIMVAR(name = cr as CREF_QUAL(ident = "$DER")) then 'inline_integrate(<%cref(cr)%>);' ;separator="\n"%>
>>
end inlineVars;


template inlineCrefs(Context context, list<ComponentRef> crefs)
::= match context case INLINE_CONTEXT(__) then match crefs
case {} then ''
else <<

<%crefs |> cr => match cr case CREF_QUAL(ident = "$DER") then 'inline_integrate(<%cref(cr)%>);' ;separator="\n"%>
>>
end inlineCrefs;


template inlineCref(Context context, ComponentRef cr)
::= match context case INLINE_CONTEXT(__) then match cr case CREF_QUAL(ident = "$DER") then <<

inline_integrate(<%cref(cr)%>);
>>
end inlineCref;


template equationSimpleAssign(SimEqSystem eq, Context context,
                              Text &varDecls /*BUFP*/)
 "Generates an equation that is just a simple assignment."
::=
match eq
case SES_SIMPLE_ASSIGN(__) then
  let &preExp = buffer "" /*BUFD*/
  let expPart = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  <<
  <%preExp%>
  <%cref(cref)%> = <%expPart%>;<%inlineCref(context,cref)%>
  >>
end equationSimpleAssign;


template equationArrayCallAssign(SimEqSystem eq, Context context,
                                 Text &varDecls /*BUFP*/)
 "Generates equation on form 'cref_array = call(...)'."
::=
match eq

case eqn as SES_ARRAY_CALL_ASSIGN(__) then
  let &preExp = buffer "" /*BUFD*/
  let expPart = daeExp(exp, context, &preExp /*BUF  let &preExp = buffer "" /*BUFD*/
  let &helpInits = buffer "" /*BUFD*/
  let helpIf = (conditions |> (e, hidx) =>
      let helpInit = daeExp(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
      let &helpInits += 'localData->helpVars[<%hidx%>] = <%helpInit%>;'
      'edge(localData->helpVars[<%hidx%>])'
    ;separator=" || ")C*/, &varDecls /*BUFC*/)
  match expTypeFromExpShort(eqn.exp)
  case "boolean" then
    let tvar = tempDecl("boolean_array", &varDecls /*BUFC*/)
    //let &preExp += 'cast_integer_array_to_real(&<%expPart%>, &<%tvar%>);<%\n%>'
    <<
    <%preExp%>
    copy_boolean_array_data_mem(&<%expPart%>, &<%cref(eqn.componentRef)%>);<%inlineArray(context,tvar,eqn.componentRef)%>
    >>
  case "integer" then
    let tvar = tempDecl("integer_array", &varDecls /*BUFC*/)
    let &preExp += 'cast_integer_array_to_real(&<%expPart%>, &<%tvar%>);<%\n%>'
    <<
    <%preExp%>
    copy_integer_array_data_mem(&<%expPart%>, &<%cref(eqn.componentRef)%>);<%inlineArray(context,tvar,eqn.componentRef)%>
    >>
  case "real" then
    <<
    <%preExp%>
    copy_real_array_data_mem(&<%expPart%>, &<%cref(eqn.componentRef)%>);<%inlineArray(context,expPart,eqn.componentRef)%>
    >>
  else "#error \"No runtime support for this sort of array call\""
end equationArrayCallAssign;


template equationAlgorithm(SimEqSystem eq, Context context, Text &varDecls /*BUFP*/)
 "Generates an equation that is an algorithm."
::=
match eq
case SES_ALGORITHM(__) then
  (statements |> stmt =>
    algStatement(stmt, context, &varDecls /*BUFC*/)
  ;separator="\n") 
end equationAlgorithm;


template equationLinear(SimEqSystem eq, Context context, Text &varDecls /*BUFP*/)
 "Generates a linear equation system."
::=
match eq
case SES_LINEAR(__) then
  let uid = System.tmpTick()
  let size = listLength(vars)
  let aname = 'A<%uid%>'
  let bname = 'b<%uid%>'
  let mixedPostfix = if partOfMixed then "_mixed" //else ""
  <<
  declare_matrix(<%aname%>, <%size%>, <%size%>);
  declare_vector(<%bname%>, <%size%>);
  <%simJac |> (row, col, eq as SES_RESIDUAL(__)) =>
     let &preExp = buffer "" /*BUFD*/
     let expPart = daeExp(eq.exp, context, &preExp /*BUFC*/,  &varDecls /*BUFC*/)
     '<%preExp%>set_matrix_elt(<%aname%>, <%row%>, <%col%>, <%size%>, <%expPart%>);'
  ;separator="\n"%>
  <%beqs |> exp indexedby i0 =>
     let &preExp = buffer "" /*BUFD*/
     let expPart = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
     '<%preExp%>set_vector_elt(<%bname%>, <%i0%>, <%expPart%>);'
  ;separator="\n"%>
  solve_linear_equation_system<%mixedPostfix%>(<%aname%>, <%bname%>, <%size%>, <%uid%>);
  <%vars |> SIMVAR(__) indexedby i0 => '<%cref(name)%> = get_vector_elt(<%bname%>, <%i0%>);' ;separator="\n"%><%inlineVars(context,vars)%>
  >>
end equationLinear;


template equationMixed(SimEqSystem eq, Context context, Text &varDecls /*BUFP*/)
 "Generates a mixed equation system."
::=
match eq
case SES_MIXED(__) then
  let contEqs = equation_(cont, context, &varDecls /*BUFC*/)
  let numDiscVarsStr = listLength(discVars) 
  let valuesLenStr = listLength(values)
  let &preDisc = buffer "" /*BUFD*/
  let discLoc2 = (discEqs |> SES_SIMPLE_ASSIGN(__) indexedby i0 =>
      let expPart = daeExp(exp, context, &preDisc /*BUFC*/, &varDecls /*BUFC*/)
      <<
      <%cref(cref)%> = <%expPart%>;
      discrete_loc2[<%i0%>] = <%cref(cref)%>;
      >>
    ;separator="\n")
  <<
  mixed_equation_system(<%numDiscVarsStr%>);
  double values[<%valuesLenStr%>] = {<%values ;separator=", "%>};
  int value_dims[<%numDiscVarsStr%>] = {<%value_dims ;separator=", "%>};
  <%discVars |> SIMVAR(__) indexedby i0 => 'discrete_loc[<%i0%>] = <%cref(name)%>;' ;separator="\n"%>
  {
    <%contEqs%>
  }
  <%preDisc%>
  <%discLoc2%>
  {
    double *loc_ptrs[<%numDiscVarsStr%>] = {<%discVars |> SIMVAR(__) => '(double*)&<%cref(name)%>' ;separator=", "%>};
    check_discrete_values(<%numDiscVarsStr%>, <%valuesLenStr%>);
  }
  mixed_equation_system_end(<%numDiscVarsStr%>);
  >>
end equationMixed;


template equationNonlinear(SimEqSystem eq, Context context, Text &varDecls /*BUFP*/)
 "Generates a non linear equation system."
::=
match eq
case SES_NONLINEAR(__) then
  let size = listLength(crefs)
  <<
  start_nonlinear_system(<%size%>);
  <%crefs |> name indexedby i0 =>
    <<
    nls_x[<%i0%>] = extraPolate(<%cref(name)%>);
    nls_xold[<%i0%>] = $P$old<%cref(name)%>;
    >>
  ;separator="\n"%>
  solve_nonlinear_system(residualFunc<%index%>, <%index%>);
  <%crefs |> name indexedby i0 => '<%cref(name)%> = nls_x[<%i0%>];' ;separator="\n"%>
  end_nonlinear_system();<%inlineCrefs(context,crefs)%>
  >>
end equationNonlinear;


template equationWhen(SimEqSystem eq, Context context, Text &varDecls /*BUFP*/)
 "Generates a when equation."
::=
match eq
case SES_WHEN(__) then
  let &preExp = buffer "" /*BUFD*/
  let &helpInits = buffer "" /*BUFD*/
  let helpIf = (conditions |> (e, hidx) =>
      let helpInit = daeExp(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
      let &helpInits += 'localData->helpVars[<%hidx%>] = <%helpInit%>;'
      'edge(localData->helpVars[<%hidx%>])'
    ;separator=" || ")
  let &preExp2 = buffer "" /*BUFD*/
  let exp = daeExp(right, context, &preExp2 /*BUFC*/, &varDecls /*BUFC*/)
  <<
  <%preExp%>
  <%helpInits%>
  if (<%helpIf%>) {
    <%preExp2%>
    <%cref(left)%> = <%exp%>;
  } else {
    <%cref(left)%> = pre(<%cref(left)%>);
  }
  >>
end equationWhen;


template simulationFunctionsFile(list<Function> functions)
 "Generates the content of the C file for functions in the simulation case."
::=
  <<
  #ifdef __cplusplus
  extern "C" {
  #endif
  
  /* Header */
  <%externalFunctionIncludes(functions)%>
  <%functionHeaders(functions)%>
  /* End Header */
  
  /* Body */
  <%functionBodies(functions)%>
  /* End Body */
  
  #ifdef __cplusplus
  }
  #endif
  
  >>
end simulationFunctionsFile;


template simulationMakefile(SimCode simCode)
 "Generates the contents of the makefile for the simulation case."
::=
match simCode
case SIMCODE(modelInfo=MODELINFO(__), makefileParams=MAKEFILE_PARAMS(__)) then
  let dirExtra = if modelInfo.directory then '-L"<%modelInfo.directory%>"' //else ""
  let libsStr = (makefileParams.libs |> lib => lib ;separator=" ")
  let libsPos1 = if not dirExtra then libsStr //else ""
  let libsPos2 = if dirExtra then libsStr // else ""
  <<
  # Makefile generated by OpenModelica
  
  CC=<%makefileParams.ccompiler%>
  CXX=<%makefileParams.cxxcompiler%>
  LINK=<%makefileParams.linker%>
  EXEEXT=<%makefileParams.exeext%>
  DLLEXT=<%makefileParams.dllext%>
  CFLAGS=-I"<%makefileParams.omhome%>/include/omc" <%makefileParams.cflags%>
  LDFLAGS=-L"<%makefileParams.omhome%>/lib/omc" <%makefileParams.ldflags%>
  SENDDATALIBS=<%makefileParams.senddatalibs%>
  
  .PHONY: <%fileNamePrefix%>
  <%fileNamePrefix%>: <%fileNamePrefix%>.cpp
  <%\t%> $(CXX) $(CFLAGS) -I. -o <%fileNamePrefix%>$(EXEEXT) <%fileNamePrefix%>.cpp <%dirExtra%> <%libsPos1%> -lsim $(LDFLAGS) -lf2c -linteractive $(SENDDATALIBS) <%libsPos2%>
  >>
end simulationMakefile;


template simulationInitFile(SimCode simCode)
 "Generates the contents of the makefile for the simulation case."
::=
match simCode
case SIMCODE(modelInfo = MODELINFO(varInfo = vi as VARINFO(__), vars = vars as SIMVARS(__)), 
             simulationSettingsOpt = SOME(s as SIMULATION_SETTINGS(__))) 
  then
  <<
  <%s.startTime%> // start value
  <%s.stopTime%> // stop value
  <%s.stepSize%> // step value
  <%s.tolerance%> // tolerance
  "<%s.method%>" // method
  "<%s.outputFormat%>" // outputFormat
  <%vi.numStateVars%> // n states
  <%vi.numAlgVars%> // n alg vars
  <%vi.numParams%> //n parameters
  <%vi.numIntParams%> // n int parameters
  <%vi.numIntAlgVars%> // n int variables
  <%vi.numBoolParams%> // n bool parameters
  <%vi.numBoolAlgVars%> // n bool variables
  <%vi.numStringParamVars%> // n string-parameters
  <%vi.numStringAlgVars%> // n string variables
  <%initVals(vars.stateVars)%>
  <%initVals(vars.derivativeVars)%>
  <%initVals(vars.algVars)%>
  <%initVals(vars.paramVars)%>
  <%initVals(vars.intParamVars)%>
  <%initVals(vars.intAlgVars)%>
  <%initVals(vars.boolParamVars)%>
  <%initVals(vars.boolAlgVars)%>    
  <%initVals(vars.stringParamVars)%>
  <%initVals(vars.stringAlgVars)%>  
  >>
end simulationInitFile;

template initVals(list<SimVar> varsLst) ::=
  varsLst |> SIMVAR(__) =>
	<<
	<%match initialValue 
  	  case SOME(v) then 
        match v
        case ICONST(__) then integer
        case RCONST(__) then real
        case SCONST(__) then '"<%Util.escapeModelicaStringToCString(string)%>"'
        case BCONST(__) then if bool then "true" else "false"
        case ENUM_LITERAL(__) then '<%index%>/*ENUM:<%dotPath(name)%>*/'
        else "*ERROR* initial value of unknown type"
      else "0.0 //default"
    %> //<%crefStr(name)%>
    >>	
  ;separator="\n"
end initVals;


template functionsFile(list<Function> functions,
                       list<RecordDeclaration> extraRecordDecls)
 "Generates the contents of the main C file for the function case."
::=
  <<
  #include "modelica.h"
  #include <algorithm>
  #include <stdio.h>
  #include <stdlib.h>
  #include <errno.h>
  
  #if defined(_MSC_VER)
    #define DLLExport   __declspec( dllexport )
  #else
    #define DLLExport /* nothing */
  #endif
  
  #if !defined(MODELICA_ASSERT)
    #define MODELICA_ASSERT(cond,msg) { if (!(cond)) fprintf(stderr,"Modelica Assert: %s!\n", msg); }
  #endif
  #if !defined(MODELICA_TERMINATE)
    #define MODELICA_TERMINATE(msg) { fprintf(stderr,"Modelica Terminate: %s!\n", msg); fflush(stderr); }
  #endif
  
  #ifdef __cplusplus
  extern "C" {
  #endif
  
  /* Header */
  <%externalFunctionIncludes(functions)%>
  <%functionHeaders(functions)%>
  <%extraRecordDecls |> rd => recordDeclaration(rd) ;separator="\n"%>
  /* End Header */
  
  /* Body */
  <%functionBodies(functions)%>
  /* End Body */
  
  #ifdef __cplusplus
  }
  #endif<%\n%>
  >>
end functionsFile;


template functionsMakefile(FunctionCode fnCode)
 "Generates the contents of the makefile for the function case."
::=
match fnCode
case FUNCTIONCODE(makefileParams=MAKEFILE_PARAMS(__)) then
  let libsStr = (makefileParams.libs ;separator=" ")
  <<
  # Makefile generated by OpenModelica
  
  CC=<%makefileParams.ccompiler%>
  CXX=<%makefileParams.cxxcompiler%>
  LINK=<%makefileParams.linker%>
  EXEEXT=<%makefileParams.exeext%>
  DLLEXT=<%makefileParams.dllext%>
  CFLAGS= -I"<%makefileParams.omhome%>/include/omc" <%makefileParams.cflags%>
  LDFLAGS= -L"<%makefileParams.omhome%>/lib/omc" <%makefileParams.ldflags%>
  
  .PHONY: <%name%>
  <%name%>: <%name%>.c
  <%\t%> $(LINK) $(CFLAGS) -o <%name%>$(DLLEXT) <%name%>.c <%libsStr%> $(LDFLAGS) -lm
  >>
end functionsMakefile;

template contextCref(ComponentRef cr, Context context)
  "Generates code for a component reference depending on which context we're in."
::=
  match context
  case FUNCTION_CONTEXT(__) then crefStr(cr)
  else cref(cr)
end contextCref;

template contextIteratorName(Ident name, Context context)
  "Generates code for an iterator variable."
::=
	match context
	case FUNCTION_CONTEXT(__) then name
	else "$P" + name
end contextIteratorName;

template cref(ComponentRef cr)
 "Generates C equivalent name for component reference."
::=
  match cr
  case CREF_IDENT(ident = "xloc") then crefStr(cr)
  case CREF_IDENT(ident = "time") then "time"
  else "$P" + crefToCStr(cr)
end cref;

template crefToCStr(ComponentRef cr)
 "Helper function to cref."
::=
  match cr
  case CREF_IDENT(__) then '<%ident%><%subscriptsToCStr(subscriptLst)%>'
  case CREF_QUAL(__) then '<%ident%><%subscriptsToCStr(subscriptLst)%>$P<%crefToCStr(componentRef)%>'
  else "CREF_NOT_IDENT_OR_QUAL"
end crefToCStr;

template subscriptsToCStr(list<Subscript> subscripts)
::=
  if subscripts then
    '$lB<%subscripts |> s => subscriptToCStr(s) ;separator="$c"%>$rB'
end subscriptsToCStr;

template subscriptToCStr(Subscript subscript)
::=
  let &preExp = buffer ""
  let &varDecls = buffer ""
  match subscript
  case INDEX(__)
  case SLICE(__) then daeExp(exp, contextSimulationNonDiscrete, &preExp, &varDecls)
  case WHOLEDIM(__) then "WHOLEDIM"
  else "UNKNOWN_SUBSCRIPT"
end subscriptToCStr;

template crefStr(ComponentRef cr)
 "Generates the name of a variable for variable name array."
::=
  match cr
  case CREF_IDENT(__) then '<%ident%><%subscriptsStr(subscriptLst)%>'
  case CREF_QUAL(ident = "$DER") then 'der(<%crefStr(componentRef)%>)'
  case CREF_QUAL(__) then '<%ident%><%subscriptsStr(subscriptLst)%>.<%crefStr(componentRef)%>'
  else "CREF_NOT_IDENT_OR_QUAL"
end crefStr;

template contextArrayCref(ComponentRef cr, Context context)
 "Generates code for an array component reference depending on the context."
::=
  match context
  case FUNCTION_CONTEXT(__) then arrayCrefStr(cr)
  else arrayCrefCStr(cr)
end contextArrayCref;

template arrayCrefCStr(ComponentRef cr)
::= '$P<%arrayCrefCStr2(cr)%>'
end arrayCrefCStr;

template arrayCrefCStr2(ComponentRef cr)
::=
	match cr
	case CREF_IDENT(__) then '<%ident%>'
	case CREF_QUAL(__) then '<%ident%>$P<%arrayCrefCStr2(componentRef)%>'
	else "CREF_NOT_IDENT_OR_QUAL"
end arrayCrefCStr2;

template arrayCrefStr(ComponentRef cr)
::=
	match cr
	case CREF_IDENT(__) then '<%ident%>'
	case CREF_QUAL(__) then '<%ident%>.<%arrayCrefStr(componentRef)%>'
	else "CREF_NOT_IDENT_OR_QUAL"
end arrayCrefStr;

template subscriptsStr(list<Subscript> subscripts)
 "Generares subscript part of the name."
::=
  if subscripts then
    '[<%subscripts |> s => subscriptStr(s) ;separator=","%>]'
end subscriptsStr;

template subscriptStr(Subscript subscript)
 "Generates a single subscript.
  Only works for constant integer indicies."

::=
  let &preExp = buffer ""
  let &varDecls = buffer ""
  match subscript
  case INDEX(__) 
  case SLICE(__) then daeExp(exp, contextFunction, &preExp, &varDecls)
  case WHOLEDIM(__) then "WHOLEDIM"
  else "UNKNOWN_SUBSCRIPT"
end subscriptStr;

template expCref(DAE.Exp ecr)
::=
  match ecr
  case CREF(__) then cref(componentRef)
  case CALL(path = IDENT(name = "der"), expLst = {arg as CREF(__)}) then
    '$P$DER<%cref(arg.componentRef)%>'
  else "ERROR_NOT_A_CREF"
end expCref;

template functionName(ComponentRef cr)
::=
  match cr
  case CREF_IDENT(__) then 
    System.stringReplace(ident, "_", "__")
  case CREF_QUAL(__) then 
    '<%System.stringReplace(ident, "_", "__")%>_<%functionName(componentRef)%>'
end functionName;

template dotPath(Path path)
 "Generates paths with components separated by dots."
::=
  match path
  case QUALIFIED(__)      then '<%name%>.<%dotPath(path)%>'

  case IDENT(__)          then name
  case FULLYQUALIFIED(__) then dotPath(path)
end dotPath;

template replaceDotAndUnderscore(String str)
 "Replace _ with __ and dot in identifiers with _"
::=
  match str
  case name then
    let str_dots = System.stringReplace(name,".", "_")  
    let str_underscores = System.stringReplace(str_dots, "_", "__")
    '<%str_underscores%>'
end replaceDotAndUnderscore;

template underscorePath(Path path)
 "Generate paths with components separated by underscores.
  Replaces also the . in identifiers with _. 
  The dot might happen for world.gravityAccleration"
::=
  match path
  case QUALIFIED(__) then
    '<%replaceDotAndUnderscore(name)%>_<%underscorePath(path)%>'
  case IDENT(__) then
    replaceDotAndUnderscore(name)
  case FULLYQUALIFIED(__) then
    underscorePath(path)
end underscorePath;


template externalFunctionIncludes(list<Function> functions)
 "Generates external includes part in function files."
::=
  <<
  #ifdef __cplusplus
  extern "C" {
  #endif
  <%functions |> EXTERNAL_FUNCTION(__) =>
    (includes ;separator="\n")
  ;separator="\n"%>
  #ifdef __cplusplus
  }
  #endif
  >>
end externalFunctionIncludes;


template functionHeaders(list<Function> functions)
 "Generates function header part in function files."
::=
  (functions |> fn =>
    match fn
    case FUNCTION(__) then
      <<
      <%recordDecls |> rd => recordDeclaration(rd) ;separator="\n"%>
      <%functionHeader(underscorePath(name), functionArguments, outVars)%>
      <%functionHeaderBoxed(underscorePath(name), functionArguments, outVars)%>
      >> 
    case EXTERNAL_FUNCTION(__) then
      <<
      <%recordDecls |> rd => recordDeclaration(rd) ;separator="\n"%>
      <%functionHeader(underscorePath(name), funArgs, outVars)%>
      <%functionHeaderBoxed(underscorePath(name), funArgs, outVars)%>
  
      <%extFunDef(fn)%>
      >> 
    case RECORD_CONSTRUCTOR(__) then
      let fname = underscorePath(name)
      let funArgsStr = (funArgs |> var as VARIABLE(__) =>
          '<%varType(var)%> <%crefStr(name)%>'
        ;separator=", ")
      let funArgsBoxedStr = if acceptMetaModelicaGrammar() then
          (funArgs |> var => funArgBoxedDefinition(var) ;separator=", ")
      let boxedHeader = if acceptMetaModelicaGrammar() then
        <<
        #define <%fname%>_rettypeboxed_1 targ1
        typedef struct <%fname%>_rettypeboxed_s {
          modelica_metatype targ1;
        } <%fname%>_rettypeboxed;
        
        DLLExport
        <%fname%>_rettypeboxed boxptr_<%fname%>(<%funArgsBoxedStr%>);
        >>
      <<
      <%recordDecls |> rd => recordDeclaration(rd) ;separator="\n"%>
      #define <%fname%>_rettype_1 targ1
      typedef struct <%fname%>_rettype_s {
        struct <%fname%> targ1;
      } <%fname%>_rettype;
      
      DLLExport 
      <%fname%>_rettype _<%fname%>(<%funArgsStr%>);

      <%boxedHeader%>
      >> 
  ;separator="\n")
end functionHeaders;

template recordDeclaration(RecordDeclaration recDecl)
 "Generates structs for a record declaration."
::=
  match recDecl
  case RECORD_DECL_FULL(__) then
    <<
    struct <%name%> {
      <%variables |> var as VARIABLE(__) => '<%varType(var)%> <%crefStr(var.name)%>;' ;separator="\n"%>
    };
    <%recordDefinition(dotPath(defPath),
                      underscorePath(defPath),
                      (variables |> VARIABLE(__) => '"<%crefStr(name)%>"' ;separator=","))%>
    >> 
  case RECORD_DECL_DEF(__) then
    <<
    <%recordDefinition(dotPath(path),
                      underscorePath(path),
                      (fieldNames |> name => '"<%name%>"' ;separator=","))%>
    >>
end recordDeclaration;


template recordDefinition(String origName, String encName, String fieldNames)
 "Generates the definition struct for a record declaration."
::=
  <<
  const char* <%encName%>__desc__fields[] = {<%fieldNames%>};
  struct record_description <%encName%>__desc = {
    "<%encName%>", /* package_record__X */
    "<%origName%>", /* package.record_X */
    <%encName%>__desc__fields
  };
  >>
end recordDefinition;

template functionHeader(String fname, list<Variable> fargs, list<Variable> outVars)
::= functionHeaderImpl(fname, fargs, outVars, false)
end functionHeader;

template functionHeaderBoxed(String fname, list<Variable> fargs, list<Variable> outVars)
::= if acceptMetaModelicaGrammar() then functionHeaderImpl(fname, fargs, outVars, true)
end functionHeaderBoxed;

template functionHeaderImpl(String fname, list<Variable> fargs, list<Variable> outVars, Boolean boxed)
 "Generates function header for a Modelica/MetaModelica function. Generates a
  boxed version of the header if boxed = true, otherwise a normal header"
::=
  let fargsStr = if boxed then 
      (fargs |> var => funArgBoxedDefinition(var) ;separator=", ") 
    else 
      (fargs |> var => funArgDefinition(var) ;separator=", ")
  let boxStr = if boxed then "boxed"
  let boxPtrStr = if boxed then "boxptr"
  let inFnStr = if boxed then "" else
    <<

    DLLExport 
    int in_<%fname%>(type_description * inArgs, type_description * outVar);
    >>
  if outVars then <<
  <%outVars |> VARIABLE(__) => '#define <%fname%>_rettype<%boxStr%>_<%i1%> targ<%i1%>' ;separator="\n"%>
  typedef struct <%fname%>_rettype<%boxStr%>_s 
  {
    <%outVars |> var as VARIABLE(__) =>
      let dimStr = match ty case ET_ARRAY(__) then
          '[<%arrayDimensions |> dim => dimension(dim) ;separator=", "%>]'
      let typeStr = if boxed then varTypeBoxed(var) else varType(var) 
      '<%typeStr%> targ<%i1%>; /* <%crefStr(name)%><%dimStr%> */'
    ;separator="\n"%>
  } <%fname%>_rettype<%boxStr%>;
  <%inFnStr%>

  DLLExport 
  <%fname%>_rettype<%boxStr%> <%boxPtrStr%>_<%fname%>(<%fargsStr%>);
  >> else <<

  DLLExport 
  void <%boxPtrStr%>_<%fname%>(<%fargsStr%>);
  >>
end functionHeaderImpl;

template funArgName(Variable var)
::=
  match var
  case VARIABLE(__) then crefStr(name)
  case FUNCTION_PTR(__) then name
end funArgName;

template funArgDefinition(Variable var)
::=
  match var
  case VARIABLE(__) then '<%varType(var)%> <%crefStr(name)%>'
  case FUNCTION_PTR(__) then 'modelica_fnptr <%name%>'
end funArgDefinition;

template funArgBoxedDefinition(Variable var)
 "A definition for a boxed variable is always of type modelica_metatype, 
  unless it's a function pointer"
::=
  match var
  case VARIABLE(__) then 'modelica_metatype <%crefStr(name)%>'
  case FUNCTION_PTR(__) then 'modelica_fnptr <%name%>'
end funArgBoxedDefinition;

template extFunDef(Function fn)
 "Generates function header for an external function."
::=
match fn
case func as EXTERNAL_FUNCTION(__) then
  let fn_name = extFunctionName(extName, language)
  let fargsStr = extFunDefArgs(extArgs, language)
  'extern <%extReturnType(extReturn)%> <%fn_name%>(<%fargsStr%>);'
end extFunDef;

template extFunctionName(String name, String language)
::=
  match language
  case "C" then '<%name%>'
  case "FORTRAN 77" then '<%name%>_'
  else "UNSUPPORTED_LANGUAGE"
end extFunctionName;

template extFunDefArgs(list<SimExtArg> args, String language)
::=
  match language
  case "C" then (args |> arg => extFunDefArg(arg) ;separator=", ")
  case "FORTRAN 77" then (args |> arg => extFunDefArgF77(arg) ;separator=", ")
  else "UNSUPPORTED_LANGUAGE"
end extFunDefArgs;

template extReturnType(SimExtArg extArg)
 "Generates return type for external function."
::=
  match extArg
  case SIMEXTARG(__)   then extType(type_)
  case SIMNOEXTARG(__) then "void"
end extReturnType;


template extType(ExpType type)
 "Generates type for external function argument or return value."
::=
  match type
  case ET_INT(__)         then "int"
  case ET_REAL(__)        then "double"
  case ET_STRING(__)      then "const char*"
  case ET_BOOL(__)        then "int"
  case ET_ARRAY(__)       then extType(ty)
  case ET_COMPLEX(complexClassType=EXTERNAL_OBJ(__))
                      then "void *"
  case ET_COMPLEX(complexClassType=RECORD(path=rname))
                      then 'struct <%underscorePath(rname)%>'
  case ET_METAOPTION(__)
  case ET_LIST(__)
  case ET_METATUPLE(__)
  case ET_UNIONTYPE(__)
  case ET_POLYMORPHIC(__)
  case ET_META_ARRAY(__)
  case ET_BOXED(__)       then "void*"
  case ET_ENUMERATION(__) then "int"
  else "OTHER_EXT_TYPE"
end extType;


template extFunDefArg(SimExtArg extArg)
 "Generates the definition of an external function argument.
  Assume that language is C for now."
::=
  match extArg
  case SIMEXTARG(cref=c, isInput=ii, isArray=ia, type_=t) then
    let name = crefStr(c)
    let typeStr = if ii then
        if ia then
          match extType(t) 
          case "const char*" then // For string arrays
            'const char* const *'
          else
            'const <%extType(t)%> *'
        else
          '<%extType(t)%>'
      else
        '<%extType(t)%>*'
    <<
    <%typeStr%> <%name%>
    >>
  case SIMEXTARGEXP(__) then
    let typeStr = extType(type_)
    <<
    <%typeStr%>
    >>
  case SIMEXTARGSIZE(cref=c) then
    let name = crefStr(c)
    let eStr = daeExpToString(exp)
    <<
    size_t <%name%>_<%eStr%>
    >>
end extFunDefArg;

template extFunDefArgF77(SimExtArg extArg)
::= 
  match extArg
  case SIMEXTARG(cref=c, isInput = true, type_=t) then
    let name = crefStr(c)
    let typeStr = 'const <%extType(t)%> *'
    '<%typeStr%> <%name%>'
  case SIMEXTARG(__) then extFunDefArg(extArg)
  case SIMEXTARGEXP(__) then extFunDefArg(extArg)
  case SIMEXTARGSIZE(__) then 'int const *'
end extFunDefArgF77;


template daeExpToString(Exp exp)
 "Helper to extFunDefArg.
  This only works for constants (or else the name of a temporary variable is
  returned)."
::=
  let &preExp = buffer "" /*BUFD*/
  let &varDecls = buffer "" /*BUFD*/
  daeExp(exp, contextFunction, &preExp /*BUFC*/, &varDecls /*BUFC*/)
end daeExpToString;


template functionBodies(list<Function> functions)
 "Generates the body for a set of functions."
::=
  (functions |> fn => functionBody(fn) ;separator="\n")
end functionBodies;


template functionBody(Function fn)
 "Generates the body for a function."
::=
  match fn
  case fn as FUNCTION(__)           then functionBodyRegularFunction(fn)
  case fn as EXTERNAL_FUNCTION(__)  then functionBodyExternalFunction(fn)
  case fn as RECORD_CONSTRUCTOR(__) then functionBodyRecordConstructor(fn)
end functionBody;


template functionBodyRegularFunction(Function fn)
 "Generates the body for a Modelica/MetaModelica function."
::=
match fn
case FUNCTION(__) then
  let()= System.tmpTickReset(1)
  let fname = underscorePath(name)
  let retType = if outVars then '<%fname%>_rettype' else "void"
  let &varDecls = buffer "" /*BUFD*/
  let &varInits = buffer "" /*BUFD*/
  let retVar = if outVars then tempDecl(retType, &varDecls /*BUFC*/)
  let stateVar = tempDecl("state", &varDecls /*BUFC*/)
  let _ = (variableDeclarations |> var =>
      varInit(var, "", i1, &varDecls /*BUFC*/, &varInits /*BUFC*/)
    )
  let funArgs = (functionArguments |> var => functionArg(var, &varInits) ;separator="\n")
  let bodyPart = (body |> stmt  => funStatement(stmt, &varDecls /*BUFC*/) ;separator="\n")
  let &outVarInits = buffer "" /*BUFD*/
  let outVarsStr = (outVars |> var =>
      varOutput(var, retVar, i1, &varDecls /*BUFC*/, &outVarInits /*BUFC*/)
      ;separator="\n"
    )
  let boxedFn = if acceptMetaModelicaGrammar() then functionBodyBoxed(fn)
  <<
  <%retType%> _<%fname%>(<%functionArguments |> var => funArgDefinition(var) ;separator=", "%>)
  {
    <%funArgs%>
    <%varDecls%>
    <%outVarInits%>
    <%stateVar%> = get_memory_state();

    <%varInits%>

    <%bodyPart%>
    
    _return:
    <%outVarsStr%>
    restore_memory_state(<%stateVar%>);
    return <%if outVars then retVar%>;
  }

  int in_<%fname%>(type_description * inArgs, type_description * outVar)
  {
    <%functionArguments |> var => '<%funArgDefinition(var)%>;' ;separator="\n"%>
    <%if outVars then '<%retType%> out;'%>
    <%functionArguments |> arg => readInVar(arg) ;separator="\n"%>
    <%if outVars then "out = "%>_<%fname%>(<%functionArguments |> var => funArgName(var) ;separator=", "%>);
    <%if outVars then (outVars |> var => writeOutVar(var, i1) ;separator="\n") else "write_noretcall(outVar);"%>
    return 0;
  }

  <%boxedFn%>
  >>
end functionBodyRegularFunction;

template functionBodyExternalFunction(Function fn)
 "Generates the body for an external function (just a wrapper)."
::=
match fn
case EXTERNAL_FUNCTION(__) then
  let()= System.tmpTickReset(1)
  let fname = underscorePath(name)
  let retType = '<%fname%>_rettype'
  let &preExp = buffer "" /*BUFD*/
  let &varDecls = buffer "" /*BUFD*/
  let &outputAlloc = buffer "" /*BUFD*/
  let stateVar = tempDecl("state", &varDecls /*BUFC*/)
  let callPart = extFunCall(fn, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  let _ = (outVars |> var =>
      varInit(var, "out", i1, &varDecls /*BUFC*/, &outputAlloc /*BUFC*/)
    )
  let boxedFn = if acceptMetaModelicaGrammar() then functionBodyBoxed(fn)
  <<
  int in_<%fname%>(type_description * inArgs, type_description * outVar)
  {
    <%funArgs |> VARIABLE(__) => '<%expTypeArrayIf(ty)%> <%crefStr(name)%>;' ;separator="\n"%>
    <%retType%> out;
    <%funArgs |> arg as VARIABLE(__) => readInVar(arg) ;separator="\n"%>
    out = _<%fname%>(<%funArgs |> VARIABLE(__) => crefStr(name) ;separator=", "%>);
    <%outVars |> var as VARIABLE(__) => writeOutVar(var, i1) ;separator="\n"%>
    return 0;
  }

  <%retType%> _<%fname%>(<%funArgs |> VARIABLE(__) => '<%expTypeArrayIf(ty)%> <%crefStr(name)%>' ;separator=", "%>)
  {
    <%varDecls%>
    <%retType%> out;
    <%stateVar%> = get_memory_state();
    <%outputAlloc%>
    <%preExp%>
    <%callPart%>
    restore_memory_state(<%stateVar%>);
    return out;
  }

  <%boxedFn%>
  >>
end functionBodyExternalFunction;


template functionBodyRecordConstructor(Function fn)
 "Generates the body for a record constructor."
::=
match fn
case RECORD_CONSTRUCTOR(__) then
  let()= System.tmpTickReset(1)
  let &varDecls = buffer "" /*BUFD*/
  let fname = underscorePath(name)
  let retType = '<%fname%>_rettype'
  let retVar = tempDecl(retType, &varDecls /*BUFC*/)
  let structType = 'struct <%fname%>'
  let structVar = tempDecl(structType, &varDecls /*BUFC*/)
  let boxedFn = if acceptMetaModelicaGrammar() then functionBodyBoxed(fn)
  <<
  <%retType%> _<%fname%>(<%funArgs |> VARIABLE(__) => '<%expTypeArrayIf(ty)%> <%crefStr(name)%>' ;separator=", "%>)
  {
    <%varDecls%>
    <%funArgs |> VARIABLE(__) => '<%structVar%>.<%crefStr(name)%> = <%crefStr(name)%>;' ;separator="\n"%>
    <%retVar%>.targ1 = <%structVar%>;
    return <%retVar%>;
  }

  <%boxedFn%>
  >>
end functionBodyRecordConstructor;

template functionBodyBoxed(Function fn)
 "Generates code for a boxed version of a function. Extracts the needed data
  from a function and calls functionBodyBoxedImpl"
::=
match fn
case FUNCTION(__) then functionBodyBoxedImpl(name, functionArguments, outVars)
case EXTERNAL_FUNCTION(__) then functionBodyBoxedImpl(name, funArgs, outVars)
case RECORD_CONSTRUCTOR(__) then boxRecordConstructor(fn) 
end functionBodyBoxed;

template functionBodyBoxedImpl(Absyn.Path name, list<Variable> funargs, list<Variable> outvars)
 "Helper template for functionBodyBoxed, does all the real work."
::=
  let() = System.tmpTickReset(1)
  let fname = underscorePath(name)
  let retType = if outvars then '<%fname%>_rettype' else "void"
  let retTypeBoxed = if outvars then '<%retType%>boxed' else "void"
  let &varDecls = buffer ""
  let retVar = if outvars then tempDecl(retTypeBoxed, &varDecls)
  let funRetVar = if outvars then tempDecl(retType, &varDecls)
  let stateVar = tempDecl("state", &varDecls)
  let &varBox = buffer ""
  let &varUnbox = buffer ""
  let args = (funargs |> arg => funArgUnbox(arg, &varDecls, &varBox) ;separator=", ")
  let retStr = (outvars |> var as VARIABLE(__) indexedby i1 =>
    let arg = '<%funRetVar%>.<%retType%>_<%i1%>'
    '<%retVar%>.<%retTypeBoxed%>_<%i1%> = <%funArgBox(arg, ty, &varUnbox, &varDecls)%>;'
    ;separator="\n")
  <<
  <%retTypeBoxed%> boxptr_<%fname%>(<%funargs |> var => funArgBoxedDefinition(var) ;separator=", "%>)
  {
    <%varDecls%>
    <%stateVar%> = get_memory_state();
    <%varBox%>
    <%if outvars then '<%funRetVar%> = '%>_<%fname%>(<%args%>);
    <%varUnbox%>
    <%retStr%>
    restore_memory_state(<%stateVar%>);
    return <%retVar%>;
  }
  >>
end functionBodyBoxedImpl;

template boxRecordConstructor(Function fn)
::=
match fn
case RECORD_CONSTRUCTOR(__) then
  let() = System.tmpTickReset(1)
  let &varDecls = buffer ""
  let &preExp = buffer ""
  let stateVar = tempDecl("state", &varDecls)
  let fname = underscorePath(name)
  let retType = '<%fname%>_rettypeboxed'
  let retVar = tempDecl(retType, &varDecls)
  /*let funArgsStr = (funArgs |> var as VARIABLE(__) =>
    let varStr = crefStr(name)
    funArgBox(varStr, ty, &preExp, &varDecls)
    ;separator=", ")*/
  let funArgsStr = (funArgs |> var as VARIABLE(__) => crefStr(name) ;separator=", ")
  let boxRetVar = tempDecl("modelica_metatype", &varDecls)
  let funArgCount = incrementInt(listLength(funArgs), 1)
  <<
  <%retType%> boxptr_<%fname%>(<%funArgs |> var => funArgBoxedDefinition(var) ;separator=", "%>)
  {
    <%varDecls%>
    <%stateVar%> = get_memory_state();

    <%preExp%>
    <%boxRetVar%> = mmc_mk_box<%funArgCount%>(3, &<%fname%>__desc, <%funArgsStr%>);
    <%retVar%>.<%retType%>_1 = <%boxRetVar%>;

    restore_memory_state(<%stateVar%>);
    return <%retVar%>;
  }
  >>
end boxRecordConstructor;

template funArgUnbox(Variable var, Text &varDecls, Text &varBox)
::=
match var
case VARIABLE(__) then
  /*match ty
  case ET_COMPLEX(complexClassType = RECORD(__)) then
    let varName = crefStr(varname)
    unboxRecord(varName, ty, &varBox, &varDecls)
  else
    let shortType = mmcExpTypeShort(ty)
    if shortType then
      let type = 'mmc__unbox__<%shortType%>_rettype'
      let tmpVar = tempDecl('mmc__unbox__<%shortType%>_rettype', &varDecls)
      let &varBox += '<%tmpVar%> = mmc__unbox__<%shortType%>(<%crefStr(varname)%>);<%\n%>'
      tmpVar
    else 
      crefStr(varname)*/
  let varName = crefStr(name)
  unboxVariable(varName, ty, &varBox, &varDecls)
case FUNCTION_PTR(__) then // Function pointers don't need to be boxed.
  name 
end funArgUnbox;

template unboxVariable(String varName, ExpType varType, Text &preExp, Text &varDecls)
::=
match varType
case ET_LIST(__)
case ET_METATUPLE(__)
case ET_METAOPTION(__)
case ET_UNIONTYPE(__)
case ET_POLYMORPHIC(__)
case ET_META_ARRAY(__)
case ET_BOXED(__) then varName
case ET_COMPLEX(complexClassType = RECORD(__)) then
  unboxRecord(varName, varType, &preExp, &varDecls)
else
  let shortType = mmcExpTypeShort(varType)
  let type = 'mmc__unbox__<%shortType%>_rettype'
  let tmpVar = tempDecl('mmc__unbox__<%shortType%>_rettype', &varDecls)
  let &preExp += '<%tmpVar%> = mmc__unbox__<%shortType%>(<%varName%>);<%\n%>'
  tmpVar
end unboxVariable;

template unboxRecord(String recordVar, ExpType ty, Text &preExp, Text &varDecls)
::=
match ty
case ET_COMPLEX(complexClassType = RECORD(path = path), varLst = vars) then
  let tmpVar = tempDecl('struct <%underscorePath(path)%>', &varDecls)
  let &preExp += (vars |> COMPLEX_VAR(name = compname) =>
    let varType = mmcExpTypeShort(tp)
    let untagTmp = tempDecl('modelica_metatype', &varDecls)
    let offsetStr = incrementInt(i1, 1)
    let &unboxBuf = buffer ""
    let unboxStr = unboxVariable(untagTmp, tp, &unboxBuf, &varDecls)
    <<
    <%untagTmp%> = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(<%recordVar%>), <%offsetStr%>)));
    <%unboxBuf%>
    <%tmpVar%>.<%compname%> = <%unboxStr%>;
    >>
    ;separator="\n")
  tmpVar
end unboxRecord; 

template funArgBox(String varName, ExpType ty, Text &varUnbox, Text &varDecls)
 "Generates code to box a variable."
::=
  let constructorType = mmcConstructorType(ty)
  if constructorType then
    let constructor = mmcConstructor(ty, varName, &varUnbox, &varDecls)
    let tmpVar = tempDecl(constructorType, &varDecls)
    let &varUnbox += '<%tmpVar%> = <%constructor%>;<%\n%>'
    tmpVar
  else // Some types don't need to be boxed, since they're already boxed.
    varName
end funArgBox;

template mmcConstructorType(ExpType type)
::=
  match type
  case ET_INT(__) then 'mmc_mk_icon_rettype'
  case ET_BOOL(__) then 'mmc_mk_icon_rettype'
  case ET_REAL(__) then 'mmc_mk_rcon_rettype'
  case ET_STRING(__) then 'mmc_mk_scon_rettype'
  case ET_ARRAY(__) then 'mmc_mk_acon_rettype'
  case ET_COMPLEX(__) then 'modelica_metatype'
end mmcConstructorType;

template mmcConstructor(ExpType type, String varName, Text &preExp, Text &varDecls)
::=
  match type
  case ET_INT(__) then 'mmc_mk_icon(<%varName%>)'
  case ET_BOOL(__) then 'mmc_mk_icon(<%varName%>)'
  case ET_REAL(__) then 'mmc_mk_rcon(<%varName%>)'
  case ET_STRING(__) then 'mmc_mk_scon(<%varName%>)'
  case ET_ARRAY(__) then 'mmc_mk_acon(<%varName%>)'
  case ET_COMPLEX(complexClassType = RECORD(path = path), varLst = vars) then
    let varCount = incrementInt(listLength(vars), 1)
    //let varsStr = (vars |> var as COMPLEX_VAR(__) => '<%varName%>.<%name%>' ;separator=", ")
    let varsStr = (vars |> var as COMPLEX_VAR(__) =>
      let varname = '<%varName%>.<%name%>'
      funArgBox(varname, tp, &preExp, &varDecls) ;separator=", ")
    'mmc_mk_box<%varCount%>(3, &<%underscorePath(path)%>__desc, <%varsStr%>)'
  case ET_COMPLEX(__) then 'mmc_mk_box(<%varName%>)'
end mmcConstructor;

template readInVar(Variable var)
 "Generates code for reading a variable from inArgs."
::=
  match var
  case VARIABLE(name=cr, ty=ET_COMPLEX(complexClassType=RECORD(__))) then
    <<
    if (read_modelica_record(&inArgs, <%readInVarRecordMembers(ty, crefStr(cr))%>)) return 1;
    >>
  case VARIABLE(__) then
    <<
    if (read_<%expTypeArrayIf(ty)%>(&inArgs, &<%crefStr(name)%>)) return 1;
    >>
end readInVar;


template readInVarRecordMembers(ExpType type, String prefix)
 "Helper to readInVar."
::=
match type
case ET_COMPLEX(varLst=vl) then
  (vl |> subvar as COMPLEX_VAR(__) =>
    match tp case ET_COMPLEX(__) then
      let newPrefix = '<%prefix%>.<%subvar.name%>'
      readInVarRecordMembers(tp, newPrefix)
    else
      '&(<%prefix%>.<%subvar.name%>)'
  ;separator=", ")
end readInVarRecordMembers;


template writeOutVar(Variable var, Integer index)
 "Generates code for writing a variable to outVar."

::=
  match var
  case VARIABLE(ty=ET_COMPLEX(complexClassType=RECORD(__))) then
    <<
    write_modelica_record(outVar, <%writeOutVarRecordMembers(ty, index, "")%>);
    >>
  case VARIABLE(__) then
    <<
    write_<%varType(var)%>(outVar, &out.targ<%index%>);
    >>
end writeOutVar;


template writeOutVarRecordMembers(ExpType type, Integer index, String prefix)
 "Helper to writeOutVar."
::=
match type
case ET_COMPLEX(varLst=vl, name=n) then
  let basename = underscorePath(n)
  let args = (vl |> subvar as COMPLEX_VAR(__) =>
      match tp case ET_COMPLEX(__) then
        let newPrefix = '<%prefix%>.<%subvar.name%>'
        '<%expTypeRW(tp)%>, <%writeOutVarRecordMembers(tp, index, newPrefix)%>'
      else
        '<%expTypeRW(tp)%>, &(out.targ<%index%><%prefix%>.<%subvar.name%>)'
    ;separator=", ")
  <<
  &<%basename%>__desc<%if args then ', <%args%>'%>, TYPE_DESC_NONE
  >>
end writeOutVarRecordMembers;


template varInit(Variable var, String outStruct, Integer i, Text &varDecls /*BUFP*/,
        Text &varInits /*BUFP*/)
 "Generates code to initialize variables.
  Does not return anything: just appends declarations to buffers."
::=
match var
case var as VARIABLE(__) then
  let &varDecls += if not outStruct then '<%varType(var)%> <%crefStr(var.name)%>;<%\n%>' //else ""
  let varName = if outStruct then '<%outStruct%>.targ<%i%>' else '<%crefStr(var.name)%>'
  let instDimsInit = (instDims |> exp =>
      daeExp(exp, contextFunction, &varInits /*BUFC*/, &varDecls /*BUFC*/)
    ;separator=", ")
  if instDims then
    let &varInits += 'alloc_<%expTypeShort(var.ty)%>_array(&<%varName%>, <%listLength(instDims)%>, <%instDimsInit%>);<%\n%>'
    let &varInits += varDefaultValue(var, outStruct, i)
    " "
  else
    " "
end varInit;

template varDefaultValue(Variable var, String outStruct, Integer i)
::=
match var
case var as VARIABLE(__) then
  match value
  case SOME(CREF(componentRef = cr)) then
    'copy_<%expTypeShort(var.ty)%>_array_data(&<%crefStr(cr)%>, &<%outStruct%>.targ<%i%>);<%\n%>'
end varDefaultValue;

template functionArg(Variable var, Text &varInit)
"Shared code for function arguments that are part of the function variables and valueblocks.
Valueblocks need to declare a reference to the function while input variables
need to initialize."
::=
match var
case var as FUNCTION_PTR(__) then
  let typelist = (args |> arg => mmcVarType(arg) ;separator=", ")
  let rettype = '<%name%>_rettype'
  match ty
    case ET_NORETCALL() then
      let &varInit += '_<%name%> = (void(*)(<%typelist%>)) <%name%>;'
      'void(*_<%name%>)(<%typelist%>);<%\n%>'
    else
      let &varInit += '_<%name%> = (<%rettype%>(*)(<%typelist%>)) <%name%>;<%\n%>'
    <<
    #define <%rettype%>_1 targ1
    typedef struct <%rettype%>_s
    {
      <%args |> arg indexedby i1 => 
        <<<%mmcVarType(arg)%> targ<%i1%>;>> ;separator="\n"%>
    } <%rettype%>;
    <%rettype%>(*_<%name%>)(<%typelist%>);
    >>
  end match
end functionArg;
  
template varOutput(Variable var, String dest, Integer i, Text &varDecls /*BUFP*/,
          Text &varInits /*BUFP*/)
 "Generates code to copy result value from a function to dest."
::=
match var
case var as VARIABLE(__) then
  let instDimsInit = (instDims |> exp =>
      daeExp(exp, contextFunction, &varInits /*BUFC*/, &varDecls /*BUFC*/)
    ;separator=", ")
  if instDims then
    let &varInits += 'alloc_<%expTypeShort(var.ty)%>_array(&<%dest%>.targ<%i%>, <%listLength(instDims)%>, <%instDimsInit%>);<%\n%>'
    <<
    copy_<%expTypeShort(var.ty)%>_array_data(&<%crefStr(var.name)%>, &<%dest%>.targ<%i%>);
    >>
  else
    let &varInits += initRecordMembers(var)
    <<
    <%dest%>.targ<%i%> = <%crefStr(var.name)%>;
    >>
end varOutput;

template initRecordMembers(Variable var)
::=
match var
case VARIABLE(ty = ET_COMPLEX(complexClassType = RECORD)) then
	let varName = crefStr(name)
	(ty.varLst |> v => recordMemberInit(v, varName) ;separator="\n")
end initRecordMembers;

template recordMemberInit(ExpVar v, Text varName)
::=
match v
case COMPLEX_VAR(tp = ET_ARRAY(__)) then 
	let arrayType = expType(tp, true) 
	let dims = (tp.arrayDimensions |> dim => dimension(dim) ;separator=", ")
	'alloc_<%arrayType%>(&<%varName%>.<%name%>, <%listLength(tp.arrayDimensions)%>, <%dims%>);'
end recordMemberInit;

template extVarName(ComponentRef cr)
::= '<%crefStr(cr)%>_ext'
end extVarName;

template extFunCall(Function fun, Text &preExp /*BUFP*/, Text &varDecls /*BUFP*/)
 "Generates the call to an external function."
::=
match fun
case EXTERNAL_FUNCTION(__) then
  match language
  case "C" then extFunCallC(fun, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case "FORTRAN 77" then extFunCallF77(fun, &preExp /*BUFC*/, &varDecls /*BUFC*/)
end extFunCall;

template extFunCallC(Function fun, Text &preExp /*BUFP*/, Text &varDecls /*BUFP*/)
 "Generates the call to an external C function."
::=
match fun
case EXTERNAL_FUNCTION(__) then
  let args = (extArgs |> arg =>
      extArg(arg, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    ;separator=", ")
  let returnAssign = match extReturn case SIMEXTARG(cref=c) then
      '<%extVarName(c)%> = '
    else
      ""
  <<
  <%extArgs |> arg => extFunCallVardecl(arg, &varDecls /*BUFC*/) ;separator="\n"%>
  <%match extReturn case SIMEXTARG(__) then extFunCallVardecl(extReturn, &varDecls /*BUFC*/)%>
  <%returnAssign%><%extName%>(<%args%>);
  <%extArgs |> arg => extFunCallVarcopy(arg) ;separator="\n"%>
  <%match extReturn case SIMEXTARG(__) then extFunCallVarcopy(extReturn)%>
  >>
end extFunCallC;

template extFunCallF77(Function fun, Text &preExp /*BUFP*/, Text &varDecls /*BUFP*/)
 "Generates the call to an external Fortran 77 function."
::=
match fun
case EXTERNAL_FUNCTION(__) then
  let args = (extArgs |> arg => extArgF77(arg, &preExp, &varDecls) ;separator=", ")
  let returnAssign = match extReturn case SIMEXTARG(cref=c) then
      '<%extVarName(c)%> = '
    else
      ""
  <<
  <%extArgs |> arg => extFunCallVardeclF77(arg, &varDecls) ;separator="\n"%>
  <%match extReturn case SIMEXTARG(__) then extFunCallVardeclF77(extReturn, &varDecls /*BUFC*/)%>
  <%biVars |> arg => extFunCallBiVarF77(arg, &preExp, &varDecls) ;separator="\n"%>
  <%returnAssign%><%extName%>_(<%args%>);
  <%extArgs |> arg => extFunCallVarcopyF77(arg) ;separator="\n"%>
  <%match extReturn case SIMEXTARG(__) then extFunCallVarcopyF77(extReturn)%>
  >>
end extFunCallF77;

template extFunCallVardecl(SimExtArg arg, Text &varDecls /*BUFP*/)
 "Helper to extFunCall."
::=
  match arg
  case SIMEXTARG(isInput=true, isArray=false, type_=ty, cref=c) then
    match ty case ET_STRING(__) then
      ""
    else
      let &varDecls += '<%extType(ty)%> <%crefStr(c)%>_ext;<%\n%>'
      <<
      <%crefStr(c)%>_ext = (<%extType(ty)%>)<%crefStr(c)%>;
      >>
  case SIMEXTARG(outputIndex=oi, isArray=false, type_=ty, cref=c) then
    match oi case 0 then
      ""
    else
      let &varDecls += '<%extType(ty)%> <%extVarName(c)%>;<%\n%>'
      ""
end extFunCallVardecl;

template extFunCallVardeclF77(SimExtArg arg, Text &varDecls)
::=
  match arg
  case SIMEXTARG(isInput = true, isArray = true, type_ = ty, cref = c) then
    let &varDecls += '<%expTypeArrayIf(ty)%> <%extVarName(c)%>;<%\n%>'
    'convert_alloc_<%expTypeArray(ty)%>_to_f77(&<%crefStr(c)%>, &<%extVarName(c)%>);'
  case SIMEXTARG(outputIndex = oi, isArray = ia, type_= ty, cref = c) then
    match oi case 0 then "" else
      let &varDecls += '<%expTypeArrayIf(ty)%> <%extVarName(c)%>;<%\n%>'
      match ia case false then "" else
        'convert_alloc_<%expTypeArray(ty)%>_to_f77(&out.targ<%oi%>, &<%extVarName(c)%>);'
  case SIMEXTARG(type_ = ty, cref = c) then
    let &varDecls += '<%expTypeArrayIf(ty)%> <%extVarName(c)%>;<%\n%>'
    ""
end extFunCallVardeclF77;

template extFunCallBiVarF77(Variable var, Text &preExp, Text &varDecls)
::=
  match var
  case var as VARIABLE(__) then
    let var_name = crefStr(name)
    let &varDecls += '<%varType(var)%> <%var_name%>;<%\n%>'
    let &varDecls += '<%varType(var)%> <%extVarName(name)%>;<%\n%>'
    let defaultValue = match value 
      case SOME(v) then
        '<%var_name%> = <%daeExp(v, contextFunction, &preExp, &varDecls)%>;<%\n%>'
      else ""
    let &preExp += defaultValue
    let instDimsInit = (instDims |> exp =>
        daeExp(exp, contextFunction, &preExp, &varDecls) ;separator=", ")
    if instDims then
      let type = expTypeArray(var.ty)
      let &preExp += 'alloc_<%type%>(&<%var_name%>, <%listLength(instDims)%>, <%instDimsInit%>);<%\n%>'
      let &preExp += 'convert_alloc_<%type%>_to_f77(&<%var_name%>, &<%extVarName(name)%>);<%\n%>'
      ""
    else
      ""
end extFunCallBiVarF77;

template extFunCallVarcopy(SimExtArg arg)
 "Helper to extFunCall."
::=
match arg
case SIMEXTARG(outputIndex=oi, isArray=false, type_=ty, cref=c) then
  match oi case 0 then
    ""
  else
    <<
    out.targ<%oi%> = (<%expTypeModelica(ty)%>)<%crefStr(c)%>_ext;
    >>
end extFunCallVarcopy;

template extFunCallVarcopyF77(SimExtArg arg)
 "Generates code to copy results from output variables into the out struct.
  Helper to extFunCallF77."
::=
match arg
case SIMEXTARG(outputIndex=oi, isArray=ai, type_=ty, cref=c) then
  match oi case 0 then
    ""
  else
    let outarg = 'out.targ<%oi%>'
    let ext_name = '<%crefStr(c)%>_ext'
    match ai 
    case false then 
      '<%outarg%> = (<%expTypeModelica(ty)%>)<%ext_name%>;<%\n%>'
    case true then
      'convert_alloc_<%expTypeArray(ty)%>_from_f77(&<%ext_name%>, &<%outarg%>);'
end extFunCallVarcopyF77;

template extArg(SimExtArg extArg, Text &preExp /*BUFP*/, Text &varDecls /*BUFP*/)
 "Helper to extFunCall."
::=
  match extArg
  case SIMEXTARG(cref=c, outputIndex=oi, isArray=true, type_=t) then
    let name = if oi then 'out.targ<%oi%>' else crefStr(c)
    let shortTypeStr = expTypeShort(t)
    'data_of_<%shortTypeStr%>_array(&(<%name%>))'
  case SIMEXTARG(cref=c, isInput=ii, outputIndex=oi, type_=t) then
    let prefix = if oi then "&" else ""
    let suffix = if oi then "_ext"
               else match t case ET_STRING(__) then ""
               else "_ext"
    '<%prefix%><%crefStr(c)%><%suffix%>'
  case SIMEXTARGEXP(__) then
    daeExp(exp, contextFunction, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case SIMEXTARGSIZE(cref=c) then
    let typeStr = expTypeShort(type_)
    let name = if outputIndex then 'out.targ<%outputIndex%>' else crefStr(c)
    let dim = daeExp(exp, contextFunction, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    'size_of_dimension_<%typeStr%>_array(<%name%>, <%dim%>)'
end extArg;

template extArgF77(SimExtArg extArg, Text &preExp, Text &varDecls)
::=
  match extArg
  case SIMEXTARG(cref=c, isArray=true, type_=t) then
    // Arrays are converted to fortran format that are stored in _ext-variables.
    'data_of_<%expTypeShort(t)%>_array(&(<%extVarName(c)%>))' 
  case SIMEXTARG(cref=c, isArray=ia, outputIndex=oi, type_=t) then
    // Always prefix fortran arguments with &.
    let suffix = if oi then 
                   "_ext"
                 else 
                   match ia case true then "_ext" else ""
    '&<%crefStr(c)%><%suffix%>'
  case SIMEXTARGEXP(__) then
    daeExp(exp, contextFunction, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case SIMEXTARGSIZE(cref=c) then
    // Fortran functions only takes references to variables, so we must store
    // the result from size_of_dimension_<type>_array in a temporary variable.
    let sizeVarName = tempSizeVarName(c, exp)
    let sizeVar = tempDecl("int", &varDecls)
    let dim = daeExp(exp, contextFunction, &preExp, &varDecls)
    let size_call = 'size_of_dimension_<%expTypeShort(type_)%>_array'
    let &preExp += '<%sizeVar%> = <%size_call%>(<%crefStr(c)%>, <%dim%>);<%\n%>'
    '&<%sizeVar%>'
end extArgF77;

template tempSizeVarName(ComponentRef c, DAE.Exp indices)
::=
  match indices
  case ICONST(__) then '<%crefStr(c)%>_size_<%integer%>'
  else "tempSizeVarName:UNHANDLED_EXPRESSION"
end tempSizeVarName;

template funStatement(Statement stmt, Text &varDecls /*BUFP*/)
 "Generates function statements."
::=
  match stmt
  case ALGORITHM(__) then
    (statementLst |> stmt =>
      algStatement(stmt, contextFunction, &varDecls /*BUFC*/)
    ;separator="\n") 
  else
    "NOT IMPLEMENTED FUN STATEMENT"
end funStatement;


template algStatement(DAE.Statement stmt, Context context, Text &varDecls /*BUFP*/)
 "Generates an algorithm statement."
::=
  match stmt
  case s as STMT_ASSIGN(__)       then algStmtAssign(s, context, &varDecls /*BUFC*/)
  case s as STMT_ASSIGN_ARR(__)   then algStmtAssignArr(s, context, &varDecls /*BUFC*/)
  case s as STMT_TUPLE_ASSIGN(__) then algStmtTupleAssign(s, context, &varDecls /*BUFC*/)
  case s as STMT_IF(__)           then algStmtIf(s, context, &varDecls /*BUFC*/)
  case s as STMT_FOR(__)          then algStmtFor(s, context, &varDecls /*BUFC*/)
  case s as STMT_WHILE(__)        then algStmtWhile(s, context, &varDecls /*BUFC*/)
  case s as STMT_ASSERT(__)       then algStmtAssert(s, context, &varDecls /*BUFC*/)
  case s as STMT_WHEN(__)         then algStmtWhen(s, context, &varDecls /*BUFC*/)
  case s as STMT_MATCHCASES(__)   then algStmtMatchcases(s, context, &varDecls /*BUFC*/)
  case s as STMT_BREAK(__)        then 'break;<%\n%>'
  case s as STMT_TRY(__)          then algStmtTry(s, context, &varDecls /*BUFC*/)
  case s as STMT_CATCH(__)        then algStmtCatch(s, context, &varDecls /*BUFC*/)
  case s as STMT_THROW(__)        then 'throw 1;<%\n%>'
  case s as STMT_RETURN(__)       then 'goto _return;<%\n%>'
  case s as STMT_NORETCALL(__)    then algStmtNoretcall(s, context, &varDecls /*BUFC*/)
  else "NOT IMPLEMENTED ALG STATEMENT"
end algStatement;


template algStmtAssign(DAE.Statement stmt, Context context, Text &varDecls /*BUFP*/)
 "Generates an assigment algorithm statement."
::=
  match stmt
  case STMT_ASSIGN(exp1=CREF(componentRef=WILD(__)), exp=e) then
    let &preExp = buffer "" /*BUFD*/
    let expPart = daeExp(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    <<
    <%preExp%>
    >>
  case STMT_ASSIGN(exp1=CREF(__)) then
    let &preExp = buffer "" /*BUFD*/
    let varPart = scalarLhsCref(exp1, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let expPart = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    <<
    <%preExp%>
    <%varPart%> = <%expPart%>;
    >>
  case STMT_ASSIGN(__) then
    let &preExp = buffer "" /*BUFD*/
    let expPart1 = daeExp(exp1, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let expPart2 = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    <<
    <%preExp%>
    <%expPart1%> = <%expPart2%>;
    >>
end algStmtAssign;


template algStmtAssignArr(DAE.Statement stmt, Context context,
                 Text &varDecls /*BUFP*/)
 "Generates an array assigment algorithm statement."
::=
match stmt
case STMT_ASSIGN_ARR(exp=e, componentRef=cr, type_=t) then
  let &preExp = buffer "" /*BUFD*/
  let expPart = daeExp(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  let ispec = indexSpecFromCref(cr, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)	
  if ispec then
    <<
    <%preExp%>
    <%indexedAssign(t, expPart, cr, ispec, context, &varDecls)%>
    >>
  else
    <<
    <%preExp%>
    <%copyArrayData(t, expPart, cr, context)%>
    >>
end algStmtAssignArr;

template indexedAssign(DAE.ExpType ty, String exp, DAE.ComponentRef cr, 
  String ispec, Context context, Text &varDecls)
::=
  let type = expTypeArray(ty)
  let cref = contextArrayCref(cr, context)
  match context
  case FUNCTION_CONTEXT(__) then
    'indexed_assign_<%type%>(&<%exp%>, &<%cref%>, &<%ispec%>);'
  else
    let tmp = tempDecl("real_array", &varDecls)
    <<
    indexed_assign_<%type%>(&<%exp%>, &<%tmp%>, &<%ispec%>);
    copy_<%type%>_data_mem(&<%tmp%>, &<%cref%>);
    >>
end indexedAssign;

template copyArrayData(DAE.ExpType ty, String exp, DAE.ComponentRef cr,
  Context context)
::=
  let type = expTypeArray(ty)
  let cref = contextArrayCref(cr, context)
  match context
  case FUNCTION_CONTEXT(__) then
    'copy_<%type%>_data(&<%exp%>, &<%cref%>);'
  else
    'copy_<%type%>_data_mem(&<%exp%>, &<%cref%>);'
end copyArrayData;
    
template algStmtTupleAssign(DAE.Statement stmt, Context context,
                   Text &varDecls /*BUFP*/)
 "Generates a tuple assigment algorithm statement."
::=
match stmt
case STMT_TUPLE_ASSIGN(exp=CALL(__)) then
  let &preExp = buffer "" /*BUFD*/
  let retStruct = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  <<
  <%preExp%>
  <%expExpLst |> cr =>
    let rhsStr = '<%retStruct%>.targ<%i1%>'
    writeLhsCref(cr, rhsStr, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  ;separator="\n"%>
  >>
end algStmtTupleAssign;

template writeLhsCref(Exp exp, String rhsStr, Context context, Text &preExp /*BUFP*/,
              Text &varDecls /*BUFP*/)
 "Generates code for writing a returnStructur to var."
::=
match exp
case CREF(ty= t as DAE.ET_ARRAY(__)) then
  let lhsStr = scalarLhsCref(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  match context case SIMULATION(__) then
    <<
    copy_<%expTypeShort(t)%>_array_data_mem(&<%rhsStr%>, &<%lhsStr%>);
    >> 
  else
    '<%lhsStr%> = <%rhsStr%>;'
case UNARY(exp = e as CREF(ty= t as DAE.ET_ARRAY(__))) then
  let lhsStr = scalarLhsCref(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  match context case SIMULATION(__) then
    <<
    usub_<%expTypeShort(t)%>_array(&<%rhsStr%>);<%\n%>
    copy_<%expTypeShort(t)%>_array_data_mem(&<%rhsStr%>, &<%lhsStr%>);
    >>
  else
    '<%lhsStr%> = -<%rhsStr%>;'
case CREF(__) then
  let lhsStr = scalarLhsCref(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  <<
  <%lhsStr%> = <%rhsStr%>;
  >>   
case UNARY(exp = e as CREF(__)) then
  let lhsStr = scalarLhsCref(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  <<
  <%lhsStr%> = -<%rhsStr%>;
  >>   
end writeLhsCref;

template algStmtIf(DAE.Statement stmt, Context context, Text &varDecls /*BUFP*/)
 "Generates an if algorithm statement."
::=
match stmt
case STMT_IF(__) then
  let &preExp = buffer "" /*BUFD*/
  let condExp = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  <<
  <%preExp%>
  if (<%condExp%>) {
    <%statementLst |> stmt => algStatement(stmt, context, &varDecls /*BUFC*/) ;separator="\n"%>
  }
  <%elseExpr(else_, context, &varDecls /*BUFC*/)%>
  >>
end algStmtIf;


template algStmtFor(DAE.Statement stmt, Context context, Text &varDecls /*BUFP*/)
 "Generates a for algorithm statement."
::=
  match stmt
  case s as STMT_FOR(exp=rng as RANGE(__)) then
    algStmtForRange(s, context, &varDecls /*BUFC*/)
  case s as STMT_FOR(__) then
    algStmtForGeneric(s, context, &varDecls /*BUFC*/)
end algStmtFor;


template algStmtForRange(DAE.Statement stmt, Context context, Text &varDecls /*BUFP*/)
 "Generates a for algorithm statement where range is RANGE."
::=
match stmt
case STMT_FOR(exp=rng as RANGE(__)) then
  let identType = expType(type_, iterIsArray)
  let identTypeShort = expTypeShort(type_)
  let stmtStr = (statementLst |> stmt => algStatement(stmt, context, &varDecls)
                 ;separator="\n")
  algStmtForRange_impl(rng, ident, identType, identTypeShort, stmtStr, context, &varDecls)
end algStmtForRange;

template algStmtForRange_impl(Exp range, Ident iterator, String type, String shortType, Text body, Context context, Text &varDecls)
 "The implementation of algStmtForRange, which is also used by daeExpReduction."
::=
match range
case RANGE(__) then
  let iterName = contextIteratorName(iterator, context)
  let stateVar = tempDecl("state", &varDecls)
  let startVar = tempDecl(type, &varDecls)
  let stepVar = tempDecl(type, &varDecls)
  let stopVar = tempDecl(type, &varDecls)
  let &preExp = buffer ""
  let startValue = daeExp(exp, context, &preExp, &varDecls)
  let stepValue = match expOption case SOME(eo) then
      daeExp(eo, context, &preExp, &varDecls)
    else
      "(1)"
  let stopValue = daeExp(range, context, &preExp, &varDecls)
  <<
  <%preExp%>
  <%startVar%> = <%startValue%>; <%stepVar%> = <%stepValue%>; <%stopVar%> = <%stopValue%>; 
  {
    for(<%type%> <%iterName%> = <%startValue%>; in_range_<%shortType%>(<%iterName%>, <%startVar%>, <%stopVar%>); <%iterName%> += <%stepVar%>) { 
      <%stateVar%> = get_memory_state();
      <%body%>
      restore_memory_state(<%stateVar%>);
    }
  }
  >>
end algStmtForRange_impl;

template algStmtForGeneric(DAE.Statement stmt, Context context, Text &varDecls /*BUFP*/)
 "Generates a for algorithm statement where range is not RANGE."
::=
match stmt
case STMT_FOR(__) then
  let iterType = expType(type_, iterIsArray)
  let arrayType = expTypeArray(type_)
  let stmtStr = (statementLst |> stmt => 
    algStatement(stmt, context, &varDecls) ;separator="\n")
  algStmtForGeneric_impl(exp, ident, iterType, arrayType, iterIsArray, stmtStr, 
    context, &varDecls)
end algStmtForGeneric;

template algStmtForGeneric_impl(Exp exp, Ident iterator, String type, 
  String arrayType, Boolean iterIsArray, Text &body, Context context, Text &varDecls)
 "The implementation of algStmtForGeneric, which is also used by daeExpReduction."
::=
  let iterName = contextIteratorName(iterator, context)
  let stateVar = tempDecl("state", &varDecls)
  let tvar = tempDecl("int", &varDecls)
  let ivar = tempDecl(type, &varDecls)
  let &preExp = buffer ""
  let evar = daeExp(exp, context, &preExp, &varDecls)
  let stmtStuff = if iterIsArray then
      'simple_index_alloc_<%type%>1(&<%evar%>, <%tvar%>, &<%ivar%>);'
    else
      '<%iterName%> = *(<%arrayType%>_element_addr1(&<%evar%>, 1, <%tvar%>));'
  <<
  <%preExp%> 
  {
  <%type%> <%iterName%>;
  
    for(<%tvar%> = 1; <%tvar%> <= size_of_dimension_<%arrayType%>(<%evar%>, 1); ++<%tvar%>) {
      <%stateVar%> = get_memory_state();
      <%stmtStuff%>
      <%body%>
      restore_memory_state(<%stateVar%>);
    }
  }
  >>
end algStmtForGeneric_impl;

template algStmtWhile(DAE.Statement stmt, Context context, Text &varDecls /*BUFP*/)
 "Generates a while algorithm statement."
::=
match stmt
case STMT_WHILE(__) then
  let &preExp = buffer "" /*BUFD*/
  let var = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  <<
  while (1) {
    <%preExp%>
    if (!<%var%>) break;
    <%statementLst |> stmt => algStatement(stmt, context, &varDecls /*BUFC*/) ;separator="\n"%>
  }
  >>
end algStmtWhile;


template algStmtAssert(DAE.Statement stmt, Context context, Text &varDecls /*BUFP*/)
 "Generates an assert algorithm statement."
::=
match stmt
case STMT_ASSERT(__) then
  let &preExp = buffer "" /*BUFD*/
  let condVar = daeExp(cond, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  let msgVar = daeExp(msg, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  <<
  <%preExp%>
  MODELICA_ASSERT(<%condVar%>, <%msgVar%>);
  >>
end algStmtAssert;


template algStmtMatchcases(DAE.Statement stmt, Context context, Text &varDecls /*BUFP*/)
 "Generates a matchcases algorithm statement."
::=
match stmt
case STMT_MATCHCASES(__) then
  let loopVar = tempDecl("modelica_integer", &varDecls /*BUFC*/)
  let doneVar = tempDecl("modelica_integer", &varDecls /*BUFC*/)
  let numCases = listLength(caseStmt)
  <<
  <%doneVar%> = 0;
  for (<%loopVar%>=0; 0==<%doneVar%> && <%loopVar%><<%numCases%>; <%loopVar%>++) {
    <% match matchType case MATCHCONTINUE(__) then 'try { /* matchcontinue */' else '{' %>
      switch (<%loopVar%>) {
        <%caseStmt |> e indexedby i0 =>
          let &preExp = buffer "" /*BUFD*/
          // the exp always seems to be a valueblock whose result should not be
          // used
          let _ = daeExp(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
          <<
          case <%i0%>: {
            <%preExp%>
            <%doneVar%> = 1;
            break;
          };
          >>
        ;separator="\n"%>
      } /* end match switch */
    <% match matchType case MATCHCONTINUE(__) then
    <<
    } catch (int i) { /* matchcontinue */
    }
    >>else '}' %>
  } /* end match for */
  if (0 == <%doneVar%>) throw 1; /* Didn't end in a valid state */
  >>
end algStmtMatchcases;


template algStmtTry(DAE.Statement stmt, Context context, Text &varDecls /*BUFP*/)
 "Generates a try algorithm statement."
::=
match stmt
case STMT_TRY(__) then
  let body = (tryBody |> stmt =>
      algStatement(stmt, context, &varDecls /*BUFC*/)
    ;separator="\n")
  <<
  try {
    <%body%>
  }
  >>
end algStmtTry;


template algStmtCatch(DAE.Statement stmt, Context context, Text &varDecls /*BUFP*/)
 "Generates a catch algorithm statement."
::=
match stmt
case STMT_CATCH(__) then
  let body = (catchBody |> stmt =>
      algStatement(stmt, context, &varDecls /*BUFC*/)
    ;separator="\n")
  <<
  catch (int i) {
    <%body%>
  }
  >>
end algStmtCatch;


template algStmtNoretcall(DAE.Statement stmt, Context context, Text &varDecls /*BUFP*/)
 "Generates a no return call algorithm statement."
::=
match stmt
case STMT_NORETCALL(__) then
  let &preExp = buffer "" /*BUFD*/
  let expPart = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  <<
  <%preExp%>
  <%expPart%>;
  >>
end algStmtNoretcall;


template algStmtWhen(DAE.Statement when, Context context, Text &varDecls /*BUFP*/)
 "Generates a when algorithm statement."
::=
match context
case SIMULATION(genDiscrete=true) then
  match when
  case STMT_WHEN(__) then
    let preIf = algStatementWhenPre(when, &varDecls /*BUFC*/)
    let statements = (statementLst |> stmt =>
        algStatement(stmt, context, &varDecls /*BUFC*/)
      ;separator="\n")
    let else = algStatementWhenElse(elseWhen, &varDecls /*BUFC*/)
    <<
    <%preIf%>
    if (<%helpVarIndices |> idx => 'edge(localData->helpVars[<%idx%>])' ;separator=" || "%>) {
      <%statements%>
    }
    <%else%>
    >>
end algStmtWhen;


template algStatementWhenPre(DAE.Statement stmt, Text &varDecls /*BUFP*/)
 "Helper to algStmtWhen."
::=
  match stmt
  case STMT_WHEN(exp=ARRAY(array=el)) then
    let restPre = match elseWhen case SOME(ew) then
        algStatementWhenPre(ew, &varDecls /*BUFC*/)
      else
        ""
    let &preExp = buffer "" /*BUFD*/
    let assignments = algStatementWhenPreAssigns(el, helpVarIndices,
                                               &preExp /*BUFC*/,
                                               &varDecls /*BUFC*/)
    <<
    <%preExp%>
    <%assignments%>
    <%restPre%>
    >>
  case when as STMT_WHEN(__) then
    match helpVarIndices
    case {i} then
      let restPre = match when.elseWhen case SOME(ew) then
          algStatementWhenPre(ew, &varDecls /*BUFC*/)
        else
          ""
      let &preExp = buffer "" /*BUFD*/
      let res = daeExp(when.exp, contextSimulationDiscrete,
                     &preExp /*BUFC*/, &varDecls /*BUFC*/)
      <<
      <%preExp%>
      localData->helpVars[<%i%>] = <%res%>;
      <%restPre%>
      >>
end algStatementWhenPre;


template algStatementWhenElse(Option<DAE.Statement> stmt, Text &varDecls /*BUFP*/)
 "Helper to algStmtWhen."
::=
match stmt
case SOME(when as STMT_WHEN(__)) then
  let statements = (when.statementLst |> stmt =>
      algStatement(stmt, contextSimulationDiscrete, &varDecls /*BUFC*/)
    ;separator="\n")
  let else = algStatementWhenElse(when.elseWhen, &varDecls /*BUFC*/)
  let elseCondStr = (when.helpVarIndices |> idx =>
      'edge(localData->helpVars[<%idx%>])'
    ;separator=" || ")
  <<
  else if (<%elseCondStr%>) {
    <%statements%>
  }
  <%else%>
  >>
end algStatementWhenElse;


template algStatementWhenPreAssigns(list<Exp> exps, list<Integer> ints,
                           Text &preExp /*BUFP*/, Text &varDecls /*BUFP*/)
 "Helper to algStatementWhenPre.
  The lists exps and ints should be of the same length. Iterating over two
  lists like this is not so well supported in Susan, so it looks a bit ugly."
::=
  match exps
  case {} then ""
  case (firstExp :: restExps) then
    match ints
    case (firstInt :: restInts) then
      let rest = algStatementWhenPreAssigns(restExps, restInts,
                                          &preExp /*BUFC*/, &varDecls /*BUFC*/)
      let firstExpPart = daeExp(firstExp, contextSimulationDiscrete,
                              &preExp /*BUFC*/, &varDecls /*BUFC*/)
      <<
      localData->helpVars[<%firstInt%>] = <%firstExpPart%>;
      <%rest%>
      >>
end algStatementWhenPreAssigns;


template indexSpecFromCref(ComponentRef cr, Context context, Text &preExp /*BUFP*/,
                  Text &varDecls /*BUFP*/)
 "Helper to algStmtAssignArr.
  Currently works only for CREF_IDENT."
::=
match cr
case CREF_IDENT(subscriptLst=subs as (_ :: _)) then
  daeExpCrefRhsIndexSpec(subs, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
end indexSpecFromCref;


template elseExpr(DAE.Else else_, Context context, Text &varDecls /*BUFP*/)
 "Helper to algStmtIf."
 ::= 
  match else_
  case NOELSE(__) then
    ""
  case ELSEIF(__) then
    let &preExp = buffer "" /*BUFD*/
    let condExp = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    <<
    else {
      <%preExp%>
      if (<%condExp%>) {
        <%statementLst |> stmt =>
          algStatement(stmt, context, &varDecls /*BUFC*/)
        ;separator="\n"%>
      }
      <%elseExpr(else_, context, &varDecls /*BUFC*/)%>
    }
    >>
  case ELSE(__) then
    <<
    else {
      <%statementLst |> stmt =>
        algStatement(stmt, context, &varDecls /*BUFC*/)
      ;separator="\n"%>
    }
    >>
end elseExpr;

template scalarLhsCref(Exp ecr, Context context, Text &preExp, Text &varDecls)
 "Generates the left hand side (for use on left hand side) of a component
  reference."
::=
  match ecr
  case CREF(componentRef = cr, ty = ET_FUNCTION_REFERENCE_VAR(__)) then
    '*((modelica_fnptr*)&_<%functionName(cr)%>)'
  case ecr as CREF(componentRef=CREF_IDENT(__)) then
    if crefNoSub(ecr.componentRef) then
      contextCref(ecr.componentRef, context)
    else
      daeExpCrefRhs(ecr, context, &preExp, &varDecls)
  case ecr as CREF(componentRef=CREF_QUAL(__)) then
    contextCref(ecr.componentRef, context)
  else
    "ONLY_IDENT_OR_QUAL_CREF_SUPPORTED_SLHS"
end scalarLhsCref;


template rhsCref(ComponentRef cr, ExpType ty)
 "Like cref but with cast if type is integer."
::=
  match cr
  case CREF_IDENT(__) then '<%rhsCrefType(ty)%><%ident%>'
  case CREF_QUAL(__)  then '<%rhsCrefType(ty)%><%ident%>.<%rhsCref(componentRef,ty)%>'
  else "rhsCref:ERROR"
end rhsCref;


template rhsCrefType(ExpType type)
 "Helper to rhsCref."
::=
  match type
  case ET_INT(__) then "(modelica_integer)"
  //else ""
end rhsCrefType;
  

template daeExp(Exp exp, Context context, Text &preExp /*BUFP*/,
       Text &varDecls /*BUFP*/)
 "Generates code for an expression."
::=
  match exp
  case e as ICONST(__)         then integer
  case e as RCONST(__)         then real
  case e as SCONST(__)         then daeExpSconst(string, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as BCONST(__)         then if bool then "(1)" else "(0)"
  case e as ENUM_LITERAL(__)   then index
  case e as CREF(__)           then daeExpCrefRhs(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as BINARY(__)         then daeExpBinary(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as UNARY(__)          then daeExpUnary(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as LBINARY(__)        then daeExpLbinary(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as LUNARY(__)         then daeExpLunary(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as RELATION(__)       then daeExpRelation(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as IFEXP(__)          then daeExpIf(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as CALL(__)           then daeExpCall(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as ARRAY(__)          then daeExpArray(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as MATRIX(__)         then daeExpMatrix(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as CAST(__)           then daeExpCast(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as ASUB(__)           then daeExpAsub(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as SIZE(__)           then daeExpSize(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as REDUCTION(__)      then daeExpReduction(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as VALUEBLOCK(__)     then daeExpValueblock(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as LIST(__)           then daeExpList(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as CONS(__)           then daeExpCons(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as META_TUPLE(__)     then daeExpMetaTuple(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as META_OPTION(__)    then daeExpMetaOption(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  case e as METARECORDCALL(__) then daeExpMetarecordcall(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  else "UNKNOWN_EXP"
end daeExp;


template daeExpSconst(String string, Text &preExp /*BUFP*/, Text &varDecls /*BUFP*/)
 "Generates code for a string constant."
::=
  let strVar = tempDecl("modelica_string", &varDecls /*BUFC*/)
  let escapedStr = Util.escapeModelicaStringToCString(string)
  let &preExp += 'init_modelica_string(&<%strVar%>,"<%escapedStr%>");<%\n%>'
  strVar  
end daeExpSconst;

template daeExpCrefRhs(Exp exp, Context context, Text &preExp /*BUFP*/,
                       Text &varDecls /*BUFP*/)
 "Generates code for a component reference on the right hand side of an
 expression."
::=
  match exp
  // A record cref without subscripts (i.e. a record instance) is handled
  // by daeExpRecordCrefRhs only in a simulation context, not in a function.
  case CREF(componentRef = cr, ty = t as ET_COMPLEX(complexClassType = RECORD(path = _))) then
    match context case FUNCTION_CONTEXT(__) then
      daeExpCrefRhs2(exp, context, &preExp, &varDecls)
    else
      daeExpRecordCrefRhs(t, cr, context, preExp, varDecls)
  case CREF(componentRef = cr, ty = ET_FUNCTION_REFERENCE_FUNC(__)) then
    '(modelica_fnptr)boxptr_<%functionName(cr)%>'
  case CREF(componentRef = cr, ty = ET_FUNCTION_REFERENCE_VAR(__)) then
    '(modelica_fnptr) _<%functionName(cr)%>'
  else daeExpCrefRhs2(exp, context, &preExp, &varDecls)
end daeExpCrefRhs;

template daeExpCrefRhs2(Exp ecr, Context context, Text &preExp /*BUFP*/,
                       Text &varDecls /*BUFP*/)
 "Generates code for a component reference."
::=
  match ecr
  case CREF(ty=ET_ENUMERATION(__)) then
    Exp.getEnumIndexfromCref(componentRef)
  case ecr as CREF(componentRef=cr, ty=ty) then
    let box = daeExpCrefRhsArrayBox(ecr, context, &preExp, &varDecls)
    if box then
      box
    else if crefIsScalar(cr, context) then
      let cast = match ty case ET_INT(__) then "(modelica_integer)" //else ""
      '<%cast%><%contextCref(cr,context)%>'
    else 
     if crefSubIsScalar(cr) then
      // The array subscript results in a scalar
      let arrName = contextCref(crefStripLastSubs(cr), context)
      let arrayType = expTypeArray(ty)
      let dimsLenStr = listLength(crefSubs(cr))
      let dimsValuesStr = (crefSubs(cr) |> INDEX(__) =>
          daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
        ;separator=", ")
      <<
      (*<%arrayType%>_element_addr(&<%arrName%>, <%dimsLenStr%>, <%dimsValuesStr%>))
      >>
    else
      // The array subscript denotes a slice
      let arrName = contextArrayCref(cr, context)
      let arrayType = expTypeArray(ty)
      let tmp = tempDecl(arrayType, &varDecls /*BUFC*/)
      let spec1 = daeExpCrefRhsIndexSpec(crefSubs(cr), context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
      let &preExp += 'index_alloc_<%arrayType%>(&<%arrName%>, &<%spec1%>, &<%tmp%>);<%\n%>'
      tmp
end daeExpCrefRhs2;

template daeExpCrefRhsIndexSpec(list<Subscript> subs, Context context,
                                Text &preExp /*BUFP*/, Text &varDecls /*BUFP*/)
 "Helper to daeExpCrefRhs."
::=
  let nridx_str = listLength(subs)
  let idx_str = (subs |> sub =>
      match sub
      case INDEX(__) then
        let expPart = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
        <<
        (0), make_index_array(1, <%expPart%>), 'S'
        >>
      case WHOLEDIM(__) then
        <<
        (1), (int*)0, 'W'
        >>
      case SLICE(__) then
        let expPart = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
        let tmp = tempDecl("modelica_integer", &varDecls /*BUFC*/)
        let &preExp += '<%tmp%> = size_of_dimension_integer_array(<%expPart%>, 1);<%\n%>'
        <<
        <%tmp%>, integer_array_make_index_array(&<%expPart%>), 'A'
        >>
    ;separator=", ")
  let tmp = tempDecl("index_spec_t", &varDecls /*BUFC*/)
  let &preExp += 'create_index_spec(&<%tmp%>, <%nridx_str%>, <%idx_str%>);<%\n%>'
  tmp
end daeExpCrefRhsIndexSpec;


template daeExpCrefRhsArrayBox(Exp ecr, Context context, Text &preExp /*BUFP*/,
                               Text &varDecls /*BUFP*/)
 "Helper to daeExpCrefRhs."
::=
match ecr
case ecr as CREF(ty=ET_ARRAY(ty=aty,arrayDimensions=dims)) then
  match context
  case FUNCTION_CONTEXT(__) then ''
  else
    // For context simulation and other array variables must be boxed into a real_array
    // object since they are represented only in a double array.
    let tmpArr = tempDecl(expTypeArray(aty), &varDecls /*BUFC*/)
    let dimsLenStr = listLength(dims)
    let dimsValuesStr = (dims |> dim => dimension(dim) ;separator=", ")
    let &preExp += '<%expTypeShort(aty)%>_array_create(&<%tmpArr%>, &<%arrayCrefCStr(ecr.componentRef)%>, <%dimsLenStr%>, <%dimsValuesStr%>);<%\n%>'
    tmpArr
end daeExpCrefRhsArrayBox;


template daeExpRecordCrefRhs(DAE.ExpType ty, ComponentRef cr, Context context, Text &preExp /*BUFP*/,
                       Text &varDecls /*BUFP*/)
::=
match ty
case ET_COMPLEX(name = record_path, varLst = var_lst) then
  let vars = var_lst |> v => daeExp(makeCrefRecordExp(cr,v), context, &preExp, &varDecls) 
             ;separator=", "
  let record_type_name = underscorePath(record_path)
  let ret_type = '<%record_type_name%>_rettype'
  let ret_var = tempDecl(ret_type, &varDecls)
  let &preExp += '<%ret_var%> = _<%record_type_name%>(<%vars%>);<%\n%>'
  '<%ret_var%>.<%ret_type%>_1'
end daeExpRecordCrefRhs;

template daeExpBinary(Exp exp, Context context, Text &preExp /*BUFP*/,
                      Text &varDecls /*BUFP*/)
 "Generates code for a binary expression."
::=

match exp
case BINARY(__) then
  let e1 = daeExp(exp1, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  let e2 = daeExp(exp2, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  match operator
  case ADD(ty = ET_STRING(__)) then
    let tmpStr = tempDecl("modelica_string", &varDecls /*BUFC*/)
    let &preExp += 'cat_modelica_string(&<%tmpStr%>,&<%e1%>,&<%e2%>);<%\n%>'
    tmpStr
  case ADD(__) then '(<%e1%> + <%e2%>)'
  case SUB(__) then '(<%e1%> - <%e2%>)'
  case MUL(__) then '(<%e1%> * <%e2%>)'
  case DIV(__) then '(<%e1%> / <%e2%>)'
  case POW(__) then 'pow((modelica_real)<%e1%>, (modelica_real)<%e2%>)'
  case UMINUS(__) then daeExpUnary(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/) 
  case ADD_ARR(__) then
    let type = match ty case ET_ARRAY(ty=ET_INT(__)) then "integer_array" else "real_array"
    let var = tempDecl(type, &varDecls /*BUFC*/)
    let &preExp += 'add_alloc_<%type%>(&<%e1%>, &<%e2%>, &<%var%>);<%\n%>'
    '<%var%>'
  case SUB_ARR(__) then
    let type = match ty case ET_ARRAY(ty=ET_INT(__)) then "integer_array" else "real_array"
    let var = tempDecl(type, &varDecls /*BUFC*/)
    let &preExp += 'sub_alloc_<%type%>(&<%e1%>, &<%e2%>, &<%var%>);<%\n%>'
    '<%var%>'
  case MUL_ARR(__) then  'daeExpBinary:ERR for MUL_ARR'  
  case DIV_ARR(__) then  'daeExpBinary:ERR for DIV_ARR'  
  case MUL_SCALAR_ARRAY(__) then
    let type = match ty case ET_ARRAY(ty=ET_INT(__)) then "integer_array" else "real_array"
    let var = tempDecl(type, &varDecls /*BUFC*/)
    let &preExp += 'mul_alloc_scalar_<%type%>(<%e1%>, &<%e2%>, &<%var%>);<%\n%>'
    '<%var%>'    
  case MUL_ARRAY_SCALAR(__) then
    let type = match ty case ET_ARRAY(ty=ET_INT(__)) then "integer_array" else "real_array"
    let var = tempDecl(type, &varDecls /*BUFC*/)
    let &preExp += 'mul_alloc_<%type%>_scalar(&<%e1%>, <%e2%>, &<%var%>);<%\n%>'
    '<%var%>'  
  case ADD_SCALAR_ARRAY(__) then 'daeExpBinary:ERR for ADD_SCALAR_ARRAY'
  case ADD_ARRAY_SCALAR(__) then 'daeExpBinary:ERR for ADD_ARRAY_SCALAR'
  case SUB_SCALAR_ARRAY(__) then 'daeExpBinary:ERR for SUB_SCALAR_ARRAY'
  case SUB_ARRAY_SCALAR(__) then 'daeExpBinary:ERR for SUB_ARRAY_SCALAR'
  case MUL_SCALAR_PRODUCT(__) then
    let type = match ty case ET_ARRAY(ty=ET_INT(__)) then "integer_scalar" else "real_scalar"
    'mul_<%type%>_product(&<%e1%>, &<%e2%>)'
  case MUL_MATRIX_PRODUCT(__) then
    let typeShort = match ty case ET_ARRAY(ty=ET_INT(__)) then "integer" else "real"
    let type = '<%typeShort%>_array'
    let var = tempDecl(type, &varDecls /*BUFC*/)
    let &preExp += 'mul_alloc_<%typeShort%>_matrix_product_smart(&<%e1%>, &<%e2%>, &<%var%>);<%\n%>'
    '<%var%>'
  case DIV_ARRAY_SCALAR(__) then
    let type = match ty case ET_ARRAY(ty=ET_INT(__)) then "integer_array" else "real_array"
    let var = tempDecl(type, &varDecls /*BUFC*/)
    let &preExp += 'div_alloc_<%type%>_scalar(&<%e1%>, <%e2%>, &<%var%>);<%\n%>'
    '<%var%>'
  case DIV_SCALAR_ARRAY(__) then 'daeExpBinary:ERR for DIV_SCALAR_ARRAY'
  case POW_ARRAY_SCALAR(__) then 'daeExpBinary:ERR for POW_ARRAY_SCALAR'
  case POW_SCALAR_ARRAY(__) then 'daeExpBinary:ERR for POW_SCALAR_ARRAY'
  case POW_ARR(__) then 'daeExpBinary:ERR for POW_ARR'
  case POW_ARR2(__) then 'daeExpBinary:ERR for POW_ARR2'
  else "daeExpBinary:ERR"
end daeExpBinary;


template daeExpUnary(Exp exp, Context context, Text &preExp /*BUFP*/,
                     Text &varDecls /*BUFP*/)
 "Generates code for a unary expression."
::=
match exp
case UNARY(__) then
  let e = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  match operator
  case UMINUS(__)     then '(-<%e%>)'
  case UPLUS(__)      then '(<%e%>)'
  case UMINUS_ARR(ty=ET_ARRAY(ty=ET_REAL(__))) then
    let &preExp += 'usub_real_array(&<%e%>);<%\n%>'
    '<%e%>'
  case UMINUS_ARR(__) then 'unary minus for non-real arrays not implemented'
  case UPLUS_ARR(__)  then "UPLUS_ARR_NOT_IMPLEMENTED"
  else "daeExpUnary:ERR"
end daeExpUnary;


template daeExpLbinary(Exp exp, Context context, Text &preExp /*BUFP*/,
                       Text &varDecls /*BUFP*/)
 "Generates code for a logical binary expression."
::=
match exp
case LBINARY(__) then
  let e1 = daeExp(exp1, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  let e2 = daeExp(exp2, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  match operator
  case AND(__) then '(<%e1%> && <%e2%>)'
  case OR(__)  then '(<%e1%> || <%e2%>)'
  else "daeExpLbinary:ERR"
end daeExpLbinary;


template daeExpLunary(Exp exp, Context context, Text &preExp /*BUFP*/,
                      Text &varDecls /*BUFP*/)
 "Generates code for a logical unary expression."
::=
match exp
case LUNARY(__) then
  let e = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  match operator
  case NOT(__) then '(!<%e%>)'
end daeExpLunary;


template daeExpRelation(Exp exp, Context context, Text &preExp /*BUFP*/,
                        Text &varDecls /*BUFP*/)
 "Generates code for a relation expression."
::=
match exp
case rel as RELATION(__) then
  let simRel = daeExpRelationSim(rel, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  if simRel then
    simRel
  else
    let e1 = daeExp(rel.exp1, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let e2 = daeExp(rel.exp2, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    match rel.operator
    case LESS(ty = ET_BOOL(__))        then '(!<%e1%> && <%e2%>)'
    case LESS(ty = ET_STRING(__))      then "# string comparison not supported\n"
    case LESS(ty = ET_INT(__))         then '(<%e1%> < <%e2%>)'
    case LESS(ty = ET_REAL(__))        then '(<%e1%> < <%e2%>)'
    case GREATER(ty = ET_BOOL(__))     then '(<%e1%> && !<%e2%>)'
    case GREATER(ty = ET_STRING(__))   then "# string comparison not supported\n"
    case GREATER(ty = ET_INT(__))      then '(<%e1%> > <%e2%>)'
    case GREATER(ty = ET_REAL(__))     then '(<%e1%> > <%e2%>)'
    case LESSEQ(ty = ET_BOOL(__))      then '(!<%e1%> || <%e2%>)'
    case LESSEQ(ty = ET_STRING(__))    then "# string comparison not supported\n"
    case LESSEQ(ty = ET_INT(__))       then '(<%e1%> <= <%e2%>)'
    case LESSEQ(ty = ET_REAL(__))      then '(<%e1%> <= <%e2%>)'
    case GREATEREQ(ty = ET_BOOL(__))   then '(<%e1%> || !<%e2%>)'
    case GREATEREQ(ty = ET_STRING(__)) then "# string comparison not supported\n"
    case GREATEREQ(ty = ET_INT(__))    then '(<%e1%> >= <%e2%>)'
    case GREATEREQ(ty = ET_REAL(__))   then '(<%e1%> >= <%e2%>)'
    case EQUAL(ty = ET_BOOL(__))       then '((!<%e1%> && !<%e2%>) || (<%e1%> && <%e2%>))'
    case EQUAL(ty = ET_STRING(__))     then '(!strcmp(<%e1%>, <%e2%>))'
    case EQUAL(ty = ET_INT(__))        then '(<%e1%> == <%e2%>)'
    case EQUAL(ty = ET_REAL(__))       then '(<%e1%> == <%e2%>)'
    case EQUAL(ty = ET_ENUMERATION(__))then '(<%e1%> == <%e2%>)'    
    case NEQUAL(ty = ET_BOOL(__))      then '((!<%e1%> && <%e2%>) || (<%e1%> && !<%e2%>))'
    case NEQUAL(ty = ET_STRING(__))    then '(strcmp(<%e1%>, <%e2%>))'
    case NEQUAL(ty = ET_INT(__))       then '(<%e1%> != <%e2%>)'
    case NEQUAL(ty = ET_REAL(__))      then '(<%e1%> != <%e2%>)'
    else "daeExpRelation:ERR"
end daeExpRelation;


template daeExpRelationSim(Exp exp, Context context, Text &preExp /*BUFP*/,
                           Text &varDecls /*BUFP*/)
 "Helper to daeExpRelation."
::=
match exp
case rel as RELATION(__) then
  match context
  case SIMULATION(__) then
    let e1 = daeExp(rel.exp1, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let e2 = daeExp(rel.exp2, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let res = tempDecl("modelica_boolean", &varDecls /*BUFC*/)
    match rel.operator
    case LESS(__) then
      let &preExp += 'RELATIONLESS(<%res%>, <%e1%>, <%e2%>);<%\n%>'
      res
    case LESSEQ(__) then
      let &preExp += 'RELATIONLESSEQ(<%res%>, <%e1%>, <%e2%>);<%\n%>'
      res
    case GREATER(__) then
      let &preExp += 'RELATIONGREATER(<%res%>, <%e1%>, <%e2%>);<%\n%>'
      res
    case GREATEREQ(__) then
      let &preExp += 'RELATIONGREATEREQ(<%res%>, <%e1%>, <%e2%>);<%\n%>'
      res
end daeExpRelationSim;


template daeExpIf(Exp exp, Context context, Text &preExp /*BUFP*/,
                  Text &varDecls /*BUFP*/)
 "Generates code for an if expression."
::=
match exp
case IFEXP(__) then
  let condExp = daeExp(expCond, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  let condVar = tempDecl("modelica_boolean", &varDecls /*BUFC*/)
  let resVarType = expTypeFromExpArrayIf(expThen)
  let resVar = tempDecl(resVarType, &varDecls /*BUFC*/)
  let &preExpThen = buffer "" /*BUFD*/
  let eThen = daeExp(expThen, context, &preExpThen /*BUFC*/, &varDecls /*BUFC*/)
  let &preExpElse = buffer "" /*BUFD*/
  let eElse = daeExp(expElse, context, &preExpElse /*BUFC*/, &varDecls /*BUFC*/)
  let &preExp +=  
  <<
  <%condVar%> = (modelica_boolean)<%condExp%>;
  if (<%condVar%>) {
    <%preExpThen%>
    <%resVar%> = <%eThen%>;
  } else {
    <%preExpElse%>
    <%resVar%> = <%eElse%>;
  }<%\n%>
  >>
  resVar
//  An alternative solution?
//  <<
//  ((<%condVar%>)?<%eThen%>:<%eElse%>)
//  >>
end daeExpIf;


template daeExpCall(Exp call, Context context, Text &preExp /*BUFP*/,
                    Text &varDecls /*BUFP*/)
 "Generates code for a function call."
::=
  match call
  // special builtins
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="DIVISION"),
            expLst={e1, e2, DAE.SCONST(string=string)}) then
    let var1 = daeExp(e1, context, preExp, varDecls)
    let var2 = daeExp(e2, context, preExp, varDecls)
    let var3 = Util.escapeModelicaStringToCString(string)
    'DIVISION(<%var1%>,<%var2%>,"<%var3%>")'
  case CALL(tuple_=false, builtin=true, ty=ty, 
            path=IDENT(name="DIVISION_ARRAY_SCALAR"),
            expLst={e1, e2, DAE.SCONST(string=string)}) then
    let type = match ty case ET_ARRAY(ty=ET_INT(__)) then "integer_array" else "real_array"
    let var = tempDecl(type, varDecls)
    let var1 = daeExp(e1, context, preExp, varDecls)
    let var2 = daeExp(e2, context, preExp, varDecls)
    let var3 = Util.escapeModelicaStringToCString(string)
    let &preExp += 'division_alloc_<%type%>_scalar(&<%var1%>, <%var2%>, &<%var%>,"<%var3%>");<%\n%>'
    '<%var%>'
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="der"), expLst={arg as CREF(__)}) then
    '$P$DER<%cref(arg.componentRef)%>'
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="pre"), expLst={arg as CREF(__)}) then
    let retType = '<%expTypeArrayIf(arg.ty)%>'
    let retVar = tempDecl(retType, &varDecls /*BUFC*/)
    let cast = match arg.ty case ET_INT(__) then "(modelica_integer)" //else ""
    let &preExp += '<%retVar%> = <%cast%>pre(<%cref(arg.componentRef)%>);<%\n%>'
    '<%retVar%>'
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="max"), expLst={e1,e2}) then
    let var1 = daeExp(e1, context, &preExp, &varDecls)
    let var2 = daeExp(e2, context, &preExp, &varDecls)
    'std::max(<%var1%>,<%var2%>)'
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="min"), expLst={e1,e2}) then
    let var1 = daeExp(e1, context, &preExp, &varDecls)
    let var2 = daeExp(e2, context, &preExp, &varDecls)
    'std::min(<%var1%>,<%var2%>)'
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="abs"), expLst={e1}, ty = ET_INT()) then
    let var1 = daeExp(e1, context, &preExp, &varDecls)
    'std::abs(<%var1%>)'
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="abs"), expLst={e1}) then
    let var1 = daeExp(e1, context, &preExp, &varDecls)
    'fabs(<%var1%>)'
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="max"), expLst={array}) then
    let expVar = daeExp(array, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let arr_tp_str = '<%expTypeFromExpArray(array)%>'
    let tvar = tempDecl(expTypeFromExpModelica(array), &varDecls /*BUFC*/)
    let &preExp += '<%tvar%> = max_<%arr_tp_str%>(&<%expVar%>);<%\n%>'
    tvar
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="min"), expLst={array}) then
    let expVar = daeExp(array, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let arr_tp_str = '<%expTypeFromExpArray(array)%>'
    let tvar = tempDecl(expTypeFromExpModelica(array), &varDecls /*BUFC*/)
    let &preExp += '<%tvar%> = min_<%arr_tp_str%>(&<%expVar%>);<%\n%>'
    tvar

  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="promote"), expLst={A, n}) then
    let var1 = daeExp(A, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let var2 = daeExp(n, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let arr_tp_str = '<%expTypeFromExpArray(A)%>'
    let tvar = tempDecl(arr_tp_str, &varDecls /*BUFC*/)
    let &preExp += 'promote_alloc_<%arr_tp_str%>(&<%var1%>, <%var2%>, &<%tvar%>);<%\n%>'
    tvar
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="transpose"), expLst={A}) then
    let var1 = daeExp(A, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let arr_tp_str = '<%expTypeFromExpArray(A)%>'
    let tvar = tempDecl(arr_tp_str, &varDecls /*BUFC*/)
    let &preExp += 'transpose_alloc_<%arr_tp_str%>(&<%var1%>, &<%tvar%>);<%\n%>'
    tvar
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="cross"), expLst={v1, v2}) then
    let var1 = daeExp(v1, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let var2 = daeExp(v2, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let arr_tp_str = '<%expTypeFromExpArray(v1)%>'
    let tvar = tempDecl(arr_tp_str, &varDecls /*BUFC*/)
    let &preExp += 'cross_alloc_<%arr_tp_str%>(&<%var1%>, &<%var2%>, &<%tvar%>);<%\n%>'
    tvar    
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="identity"), expLst={A}) then
    let var1 = daeExp(A, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let arr_tp_str = '<%expTypeFromExpArray(A)%>'
    let tvar = tempDecl(arr_tp_str, &varDecls /*BUFC*/)
    let &preExp += 'identity_alloc_<%arr_tp_str%>(<%var1%>, &<%tvar%>);<%\n%>'
    tvar
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="String"),
            expLst={s, minlen, leftjust, signdig}) then
    let tvar = tempDecl("modelica_string", &varDecls /*BUFC*/)
    let sExp = daeExp(s, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let minlenExp = daeExp(minlen, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let leftjustExp = daeExp(leftjust, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let signdigExp = daeExp(signdig, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let typeStr = expTypeFromExpModelica(s)
    let &preExp += '<%typeStr%>_to_modelica_string(&<%tvar%>, <%sExp%>, <%minlenExp%>, <%leftjustExp%>, <%signdigExp%>);<%\n%>'
    tvar
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="delay"),
            expLst={ICONST(integer=index), e, d, delayMax}) then
    let tvar = tempDecl("modelica_real", &varDecls /*BUFC*/)
    let var1 = daeExp(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let var2 = daeExp(d, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let var3 = daeExp(delayMax, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let &preExp += '<%tvar%> = delayImpl(<%index%>, <%var1%>, time, <%var2%>, <%var3%>);<%\n%>'
    tvar
  case CALL(tuple_=false, builtin=true,
            path=IDENT(name="mmc_get_field"),
            expLst={s1, ICONST(integer=i)}) then
    let tvar = tempDecl("modelica_metatype", &varDecls /*BUFC*/)
    let expPart = daeExp(s1, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let &preExp += '<%tvar%> = MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(<%expPart%>), <%i%>));<%\n%>'
    tvar
  case CALL(tuple_=false, builtin=true, path=IDENT(name = "mmc_unbox_record"),

            expLst={s1}, ty=ty) then
    let argStr = daeExp(s1, context, &preExp, &varDecls)
    unboxRecord(argStr, ty, &preExp, &varDecls)
  // no return calls
  case CALL(ty=ET_NORETCALL(__)) then
    let argStr = (expLst |> exp => '<%daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)%>' ;separator=", ")
    let funName = '<%underscorePath(path)%>'
    let &preExp += '<%daeExpCallBuiltinPrefix(builtin)%><%funName%>(<%argStr%>);<%\n%>'
    '/* NORETCALL */'
  // non tuple calls (single return value)
  case CALL(tuple_=false) then
    let argStr = (expLst |> exp => '<%daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)%>' ;separator=", ")
    let funName = '<%underscorePath(path)%>'
    let retType = '<%funName%>_rettype'
    let retVar = tempDecl(retType, &varDecls /*BUFC*/)
    let &preExp += '<%retVar%> = <%daeExpCallBuiltinPrefix(builtin)%><%funName%>(<%argStr%>);<%\n%>'
    if builtin then '<%retVar%>' else '<%retVar%>.<%retType%>_1'
  // tuple calls (multiple return values)
  case CALL(tuple_=true) then
    let argStr = (expLst |> exp => '<%daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)%>' ;separator=", ")
    let funName = '<%underscorePath(path)%>'
    let retType = '<%funName%>_rettype'
    let retVar = tempDecl(retType, &varDecls /*BUFC*/)
    let &preExp += '<%retVar%> = <%daeExpCallBuiltinPrefix(builtin)%><%funName%>(<%argStr%>);<%\n%>'
    retVar
end daeExpCall;


template daeExpCallBuiltinPrefix(Boolean builtin)
 "Helper to daeExpCall."
::=
  match builtin
  case true  then ""
  case false then "_"
end daeExpCallBuiltinPrefix;


template daeExpArray(Exp exp, Context context, Text &preExp /*BUFP*/,
                     Text &varDecls /*BUFP*/)
 "Generates code for an array expression."
::=
match exp
case ARRAY(__) then
  let arrayTypeStr = expTypeArray(ty)
  let arrayVar = tempDecl(arrayTypeStr, &varDecls /*BUFC*/)
  let scalarPrefix = if scalar then "scalar_" else ""
  let scalarRef = if scalar then "&" else ""
  let params = (array |> e =>
      let prefix = if scalar then '(<%expTypeFromExpModelica(e)%>)' else '&'
      '<%prefix%><%daeExp(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)%>'
    ;separator=", ")
  let &preExp += 'array_alloc_<%scalarPrefix%><%arrayTypeStr%>(&<%arrayVar%>, <%listLength(array)%>, <%params%>);<%\n%>'
  arrayVar
end daeExpArray;


template daeExpMatrix(Exp exp, Context context, Text &preExp /*BUFP*/,
                      Text &varDecls /*BUFP*/)
 "Generates code for a matrix expression."
::=
  match exp
  case MATRIX(scalar={{}})  // special case for empty matrix: create dimensional array Real[0,1]
  case MATRIX(scalar={})    // special case for empty array: create dimensional array Real[0,1] 
    then    
    let arrayTypeStr = expTypeArray(ty)
    let tmp = tempDecl(arrayTypeStr, &varDecls /*BUFC*/)
    let &preExp += 'alloc_<%arrayTypeStr%>(&<%tmp%>, 2, 0, 1);<%\n%>'
    tmp
  case m as MATRIX(__) then
    let arrayTypeStr = expTypeArray(m.ty)
    let &vars2 = buffer "" /*BUFD*/
    let &promote = buffer "" /*BUFD*/
    let catAlloc = (m.scalar |> row =>
        let tmp = tempDecl(arrayTypeStr, &varDecls /*BUFC*/)
        let vars = daeExpMatrixRow(row, arrayTypeStr, context,
                                 &promote /*BUFC*/, &varDecls /*BUFC*/)
        let &vars2 += ', &<%tmp%>'
        'cat_alloc_<%arrayTypeStr%>(2, &<%tmp%>, <%listLength(row)%><%vars%>);'
      ;separator="\n")
    let &preExp += promote
    let &preExp += catAlloc
    let &preExp += "\n"
    let tmp = tempDecl(arrayTypeStr, &varDecls /*BUFC*/)
    let &preExp += 'cat_alloc_<%arrayTypeStr%>(1, &<%tmp%>, <%listLength(m.scalar)%><%vars2%>);<%\n%>'
    tmp
end daeExpMatrix;


template daeExpMatrixRow(list<tuple<Exp,Boolean>> row, String arrayTypeStr,
                         Context context, Text &preExp /*BUFP*/,
                         Text &varDecls /*BUFP*/)
 "Helper to daeExpMatrix."
::=
  let &varLstStr = buffer "" /*BUFD*/
  let preExp2 = (row |> col as (e, b) =>
      let scalarStr = if b then "scalar_" else ""
      let scalarRefStr = if b then "" else "&"
      let expVar = daeExp(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
      let tmp = tempDecl(arrayTypeStr, &varDecls /*BUFC*/)
      let &varLstStr += ', &<%tmp%>'
      'promote_<%scalarStr%><%arrayTypeStr%>(<%scalarRefStr%><%expVar%>, 2, &<%tmp%>);'
    ;separator="\n")
  let &preExp2 += "\n"
  let &preExp += preExp2
  varLstStr
end daeExpMatrixRow;


template daeExpCast(Exp exp, Context context, Text &preExp /*BUFP*/,
                    Text &varDecls /*BUFP*/)
 "Generates code for a cast expression."
::=
match exp
case CAST(__) then
  let expVar = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  match ty
  case ET_INT(__)   then '((modelica_integer)<%expVar%>)'
  case ET_REAL(__)  then '((modelica_real)<%expVar%>)'
  case ET_ARRAY(__) then
    let arrayTypeStr = expTypeArray(ty)
    let tvar = tempDecl(arrayTypeStr, &varDecls /*BUFC*/)
    let to = expTypeShort(ty)
    let from = expTypeFromExpShort(exp)
    let &preExp += 'cast_<%from%>_array_to_<%to%>(&<%expVar%>, &<%tvar%>);<%\n%>'
    tvar
end daeExpCast;


template daeExpAsub(Exp exp, Context context, Text &preExp /*BUFP*/,
                    Text &varDecls /*BUFP*/)
 "Generates code for an asub expression."
::=
  match exp
  case ASUB(exp=RANGE(ty=t), sub={idx}) then
    'ASUB_EASY_CASE'
  case ASUB(exp=ASUB(
              exp=ASUB(
                exp=ASUB(exp=e, sub={ICONST(integer=i)}),
                sub={ICONST(integer=j)}),
              sub={ICONST(integer=k)}),
            sub={ICONST(integer=l)}) then
    let e1 = daeExp(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let typeShort = expTypeFromExpShort(e)
    '<%typeShort%>_get_4D(&<%e1%>, <%incrementInt(i,-1)%>, <%incrementInt(j,-1)%>, <%incrementInt(k,-1)%>, <%incrementInt(l,-1)%>)'            
  case ASUB(exp=ASUB(
              exp=ASUB(exp=e, sub={ICONST(integer=i)}),
              sub={ICONST(integer=j)}),
            sub={ICONST(integer=k)}) then
    let e1 = daeExp(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let typeShort = expTypeFromExpShort(e)
    '<%typeShort%>_get_3D(&<%e1%>, <%incrementInt(i,-1)%>, <%incrementInt(j,-1)%>, <%incrementInt(k,-1)%>)'            
  case ASUB(exp=ASUB(exp=e, sub={ICONST(integer=i)}),
            sub={ICONST(integer=j)}) then
    let e1 = daeExp(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let typeShort = expTypeFromExpShort(e)
    '<%typeShort%>_get_2D(&<%e1%>, <%incrementInt(i,-1)%>, <%incrementInt(j,-1)%>)'            
  case ASUB(exp=e, sub={ICONST(integer=i)}) then
    let e1 = daeExp(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let typeShort = expTypeFromExpShort(e)
    '<%typeShort%>_get(&<%e1%>, <%incrementInt(i,-1)%>)'
  case ASUB(exp=ecr as CREF(__), sub=subs) then
    let arrName = daeExpCrefRhs(buildCrefExpFromAsub(ecr, subs), context,
                              &preExp /*BUFC*/, &varDecls /*BUFC*/)
    match context case FUNCTION_CONTEXT(__)  then
      arrName
    else
      arrayScalarRhs(ecr.ty, subs, arrName, context, &preExp, &varDecls)
      
  else
    'OTHER_ASUB'
end daeExpAsub;


template daeExpSize(Exp exp, Context context, Text &preExp /*BUFP*/,
                    Text &varDecls /*BUFP*/)
 "Generates code for a size expression."
::=
  match exp
  case SIZE(exp=CREF(__), sz=SOME(dim)) then
    let expPart = daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let dimPart = daeExp(dim, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let resVar = tempDecl("modelica_integer", &varDecls /*BUFC*/)
    let typeStr = '<%expTypeArray(exp.ty)%>'
    let &preExp += '<%resVar%> = size_of_dimension_<%typeStr%>(<%expPart%>, <%dimPart%>);<%\n%>'
    resVar
  else "size(X) not implemented"
end daeExpSize;


template daeExpReduction(Exp exp, Context context, Text &preExp /*BUFP*/,
                         Text &varDecls /*BUFP*/)
 "Generates code for a reduction expression."
::=
match exp
case REDUCTION(path = IDENT(name = op)) then
  let identType = expTypeFromExpModelica(expr)
  let accFun = daeExpReductionFnName(op, identType)
  let startValue = daeExpReductionStartValue(op, identType)
  let res = tempDecl(identType, &varDecls)
  let &tmpExpPre = buffer ""
  let tmpExpVar = daeExp(expr, context, &tmpExpPre, &varDecls)
  let cast = match accFun case "max" then "(modelica_real)"
                          case "min" then "(modelica_real)"
                          else ""
  let body =
    <<
    <%tmpExpPre%>
    <%res%> = <%accFun%>(<%cast%>(<%res%>), <%cast%>(<%tmpExpVar%>));
    >>
  let &preExp +=
    <<
    <%res%> = <%startValue%>;
    <%daeExpReductionLoop(exp, body, context, &varDecls)%>
    >>
  res
end daeExpReduction;

template daeExpReductionLoop(Exp exp, Text &body, Context context, Text &varDecls)
 "Generates code for the loop part of a reduction expression by using the
  appropriate for loop template."
::=
match exp
case REDUCTION(range = RANGE(__)) then
  let identType = expTypeModelica(range.ty)
  let identTypeShort = expTypeFromExpShort(expr)
  algStmtForRange_impl(range, ident, identType, identTypeShort, body, context, &varDecls)
case REDUCTION(range = range) then
  let identType = expTypeFromExpModelica(expr)
  let arrayType = expTypeFromExpArray(expr)
  algStmtForGeneric_impl(range, ident, identType, arrayType, false, body, context, &varDecls)
end daeExpReductionLoop;
  

template daeExpReductionFnName(String reduction_op, String type)
 "Helper to daeExpReduction."
::=
  match reduction_op
  case "sum" then
    match type
    case "modelica_integer" then "intAdd"
    case "modelica_real" then "realAdd"
    else "INVALID_TYPE"
    end match
  case "product" then
    match type
    case "modelica_integer" then "intMul"
    case "modelica_real" then "realMul"
    else "INVALID_TYPE"
    end match  
  else reduction_op
end daeExpReductionFnName;


template daeExpReductionStartValue(String reduction_op, String type)
 "Helper to daeExpReduction."
::=
  match reduction_op
  case "min" then
    match type
    case "modelica_integer" then "1073741823"
    case "modelica_real" then "1.e60"
    else "INVALID_TYPE"
    end match
  case "max" then 
    match type

    case "modelica_integer" then "-1073741823"
    case "modelica_real" then "-1.e60"
    else "INVALID_TYPE"
    end match
  case "sum" then "0"
  case "product" then "1"
  else "UNKNOWN_REDUCTION"
end daeExpReductionStartValue;


template daeExpValueblock(Exp exp, Context context, Text &preExp /*BUFP*/,
                          Text &varDecls /*BUFP*/)
 "Generates code for a valueblock expression."
::=
match exp
case exp as VALUEBLOCK(__) then
  let &preExpInner = buffer "" /*BUFD*/
  let &preExpRes = buffer "" /*BUFD*/
  let &varDeclsInner = buffer "" /*BUFD*/
  let &ignore = buffer ""
  let _ = (valueblockVars(exp) |> var =>
      varInit(var, "", 0, &varDeclsInner /*BUFC*/, &preExpInner /*BUFC*/)
    )
  let funArgs = (valueblockVars(exp) |> var => functionArg(var, &ignore) ;separator="\n")
  let resType = expTypeModelica(ty)
  let res = tempDecl(expTypeModelica(ty), &preExp /*BUFC*/)
  let stmts = (body |> stmt =>
      algStatement(stmt, context, &varDeclsInner /*BUFC*/)
    ;separator="\n")
  let expPart = daeExp(result, context, &preExpRes /*BUFC*/,
                     &varDeclsInner /*BUFC*/)
  let &preExp +=
      <<
      {
        <%varDeclsInner%>
        <%funArgs%>
        <%preExpInner%>
        <%stmts%>
        <%preExpRes%>
        <%res%> = <%expPart%>;
      }
      >>
  res
end daeExpValueblock;

// TODO: Optimize as in Codegen
// TODO: Use this function in other places where almost the same thing is hard
//       coded
template arrayScalarRhs(ExpType ty, list<Exp> subs, String arrName, Context context,
               Text &preExp /*BUFP*/, Text &varDecls /*BUFP*/)
 "Helper to daeExpAsub."
::=
  let arrayType = expTypeArray(ty)
  let dimsLenStr = listLength(subs)
  let dimsValuesStr = (subs |> exp =>
      daeExp(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    ;separator=", ")
  <<
  (*<%arrayType%>_element_addr(&<%arrName%>, <%dimsLenStr%>, <%dimsValuesStr%>))
  >>
end arrayScalarRhs;

template daeExpList(Exp exp, Context context, Text &preExp /*BUFP*/,
                    Text &varDecls /*BUFP*/)
 "Generates code for a meta modelica list expression."
::=
match exp
case LIST(__) then
  let tmp = tempDecl("modelica_metatype", &varDecls /*BUFC*/)
  let expPart = daeExpListToCons(valList, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  let &preExp += '<%tmp%> = <%expPart%>;<%\n%>'
  tmp
end daeExpList;


template daeExpListToCons(list<Exp> listItems, Context context, Text &preExp /*BUFP*/,
                          Text &varDecls /*BUFP*/)
 "Helper to daeExpList."
::=
  match listItems
  case {} then "mmc_mk_nil()"
  case e :: rest then
    let expPart = daeExpMetaHelperConstant(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    let restList = daeExpListToCons(rest, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    <<
    mmc_mk_cons(<%expPart%>, <%restList%>)
    >>
end daeExpListToCons;


template daeExpCons(Exp exp, Context context, Text &preExp /*BUFP*/,
                    Text &varDecls /*BUFP*/)
 "Generates code for a meta modelica cons expression."
::=
match exp
case CONS(__) then
  let tmp = tempDecl("modelica_metatype", &varDecls /*BUFC*/)
  let carExp = daeExpMetaHelperConstant(car, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  let cdrExp = daeExp(cdr, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  let &preExp += '<%tmp%> = mmc_mk_cons(<%carExp%>, <%cdrExp%>);<%\n%>'
  tmp
end daeExpCons;


template daeExpMetaTuple(Exp exp, Context context, Text &preExp /*BUFP*/,
                         Text &varDecls /*BUFP*/)
 "Generates code for a meta modelica tuple expression."
::=
match exp
case META_TUPLE(__) then
  let start = daeExpMetaHelperBoxStart(listLength(listExp))
  let args = (listExp |> e =>
      daeExpMetaHelperConstant(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    ;separator=", ")
  let tmp = tempDecl("modelica_metatype", &varDecls /*BUFC*/)
  let &preExp += '<%tmp%> = mmc_mk_box<%start%>0, <%args%>);<%\n%>'
  tmp
end daeExpMetaTuple;


template daeExpMetaOption(Exp exp, Context context, Text &preExp /*BUFP*/,
                          Text &varDecls /*BUFP*/)
 "Generates code for a meta modelica option expression."
::=
  match exp
  case META_OPTION(exp=NONE) then
    "mmc_mk_none()"
  case META_OPTION(exp=SOME(e)) then
    let expPart = daeExpMetaHelperConstant(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
    'mmc_mk_some(<%expPart%>)'
end daeExpMetaOption;


template daeExpMetarecordcall(Exp exp, Context context, Text &preExp /*BUFP*/,
                              Text &varDecls /*BUFP*/)
 "Generates code for a meta modelica record call expression."
::=
match exp
case METARECORDCALL(__) then
  let newIndex = incrementInt(index, 3)
  let argsStr = if args then
      ', <%args |> exp =>
        daeExpMetaHelperConstant(exp, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
      ;separator=", "%>'
    else
      ""
  let box = 'mmc_mk_box<%daeExpMetaHelperBoxStart(incrementInt(listLength(args), 1))%><%newIndex%>, &<%underscorePath(path)%>__desc<%argsStr%>)'
  let tmp = tempDecl("modelica_metatype", &varDecls /*BUFC*/)
  let &preExp += '<%tmp%> = <%box%>;<%\n%>'
  tmp
end daeExpMetarecordcall;


template daeExpMetaHelperConstant(Exp e, Context context, Text &preExp /*BUFP*/,
                                  Text &varDecls /*BUFP*/)
 "Generates a constant meta modelica value."
::=
  let expPart = daeExp(e, context, &preExp /*BUFC*/, &varDecls /*BUFC*/)
  daeExpMetaHelperConstantNameType(expPart, Exp.typeof(e),
                                   &preExp /*BUFC*/, &varDecls /*BUFC*/)
end daeExpMetaHelperConstant;


template daeExpMetaHelperConstantNameType(Text varname, ExpType type,
                                          Text &preExp /*BUFP*/,
                                          Text &varDecls /*BUFP*/)
 "Helper to daeExpMetaHelperConstant."
::=
  match type
  case ET_INT(__)     then 'mmc_mk_icon(<%varname%>)'
  case ET_BOOL(__)    then 'mmc_mk_icon(<%varname%>)'
  case ET_REAL(__)    then 'mmc_mk_rcon(<%varname%>)'
  case ET_STRING(__)  then 'mmc_mk_scon(<%varname%>)'
  case ET_COMPLEX(name=cname) then
    let start = daeExpMetaHelperBoxStart(incrementInt(listLength(varLst), 1))
    let args = if varLst then
        ', <%varLst |> v as COMPLEX_VAR(name=cvname) =>
          let nameText = '<%varname%>.<%cvname%>'
          daeExpMetaHelperConstantNameType(nameText, tp,
                                           &preExp /*BUFC*/, &varDecls /*BUFC*/)
        ;separator=", "%>'
      else
        ""
    'mmc_mk_box<%start%>2, &<%underscorePath(cname)%>__desc<%args%>)'
  else varname
end daeExpMetaHelperConstantNameType;


template daeExpMetaHelperBoxStart(Integer numVariables)
 "Helper to determine how mmc_mk_box should be called."
::=
  match numVariables
  case 0
  case 1
  case 2
  case 3
  case 4
  case 5
  case 6
  case 7
  case 8
  case 9 then '<%numVariables%>('
  else '(<%numVariables%>, '
end daeExpMetaHelperBoxStart;


template tempDecl(String ty, Text &varDecls /*BUFP*/)
 "Declares a temporary variable in varDecls and returns the name."
::=
  let newVar = 'tmp<%System.tmpTick()%>'
  let &varDecls += '<%ty%> <%newVar%>;<%\n%>'
  newVar
end tempDecl;


template varType(Variable var)
 "Generates type for a variable."
::=
match var
case var as VARIABLE(__) then
  if instDims then
    expTypeArray(var.ty)
  else
    expTypeArrayIf(var.ty)
end varType;

template varTypeBoxed(Variable var)
::=
match var
case VARIABLE(__) then 'modelica_metatype'
case FUNCTION_PTR(__) then 'modelica_fnptr'
end varTypeBoxed;

template expTypeRW(DAE.ExpType type)
 "Helper to writeOutVarRecordMembers."
::=
  match type
  case ET_INT(__)         then "TYPE_DESC_INT"
  case ET_REAL(__)        then "TYPE_DESC_REAL"
  case ET_STRING(__)      then "TYPE_DESC_STRING"
  case ET_BOOL(__)        then "TYPE_DESC_BOOL"
  case ET_ARRAY(__)       then '<%expTypeRW(ty)%>_ARRAY'
  case ET_COMPLEX(complexClassType=RECORD(__))
                      then "TYPE_DESC_RECORD"
  case ET_METAOPTION(__)
  case ET_LIST(__)
  case ET_METATUPLE(__)
  case ET_UNIONTYPE(__)
  case ET_POLYMORPHIC(__)
  case ET_META_ARRAY(__)
  case ET_BOXED(__)       then "TYPE_DESC_MMC"
end expTypeRW;

template expTypeShort(DAE.ExpType type)
 "Generate type helper."
::=
  match type
  case ET_INT(__)         then "integer"  
  case ET_REAL(__)        then "real"
  case ET_STRING(__)      then "string"
  case ET_BOOL(__)        then "boolean"
  case ET_ENUMERATION(__) then "integer"  
  case ET_OTHER(__)       then "complex"
  case ET_ARRAY(__)       then expTypeShort(ty)   
  case ET_COMPLEX(complexClassType=EXTERNAL_OBJ(__))
                      then "complex"
  case ET_COMPLEX(__)     then 'struct <%underscorePath(name)%>'  
  case ET_LIST(__)
  case ET_METATUPLE(__)
  case ET_METAOPTION(__)
  case ET_UNIONTYPE(__)
  case ET_POLYMORPHIC(__)
  case ET_META_ARRAY(__)
  case ET_BOXED(__)       then "metatype"
  case ET_FUNCTION_REFERENCE_VAR(__) then "fnptr"
  else "expTypeShort:ERROR"
end expTypeShort;

template mmcVarType(Variable var)
::=
  match var
  case VARIABLE(__) then 'modelica_<%mmcExpTypeShort(ty)%>'
  case FUNCTION_PTR(__) then 'modelica_fnptr'
end mmcVarType;

template mmcExpTypeShort(DAE.ExpType type)
::=
  match type
  case ET_INT(__)                     then "integer"
  case ET_REAL(__)                    then "real"
  case ET_STRING(__)                  then "string"
  case ET_BOOL(__)                    then "integer"
  case ET_ARRAY(__)                   then "array"
  case ET_LIST(__)
  case ET_METATUPLE(__)
  case ET_METAOPTION(__)
  case ET_UNIONTYPE(__)
  case ET_POLYMORPHIC(__)
  case ET_META_ARRAY(__)
  case ET_BOXED(__)                  then "metatype"
  case ET_FUNCTION_REFERENCE_VAR(__)  then "fnptr"
  else "mmcExpTypeShort:ERROR"
end mmcExpTypeShort;

template expType(DAE.ExpType ty, Boolean array)
 "Generate type helper."
::=
  match array
  case true  then expTypeArray(ty)
  case false then expTypeModelica(ty)
end expType;


template expTypeModelica(DAE.ExpType ty)
 "Generate type helper."
::=
  expTypeFlag(ty, 2)
end expTypeModelica;


template expTypeArray(DAE.ExpType ty)
 "Generate type helper."
::=
  expTypeFlag(ty, 3)
end expTypeArray;


template expTypeArrayIf(DAE.ExpType ty)
 "Generate type helper."
::=
  expTypeFlag(ty, 4)
end expTypeArrayIf;


template expTypeFromExpShort(Exp exp)
 "Generate type helper."
::=
  expTypeFromExpFlag(exp, 1)
end expTypeFromExpShort;


template expTypeFromExpModelica(Exp exp)
 "Generate type helper."
::=
  expTypeFromExpFlag(exp, 2)
end expTypeFromExpModelica;


template expTypeFromExpArray(Exp exp)
 "Generate type helper."
::=
  expTypeFromExpFlag(exp, 3)
end expTypeFromExpArray;


template expTypeFromExpArrayIf(Exp exp)
 "Generate type helper."
::=
  expTypeFromExpFlag(exp, 4)
end expTypeFromExpArrayIf;


template expTypeFlag(DAE.ExpType ty, Integer flag)
 "Generate type helper."
::=
  match flag
  case 1 then
    // we want the short type
    expTypeShort(ty)
  case 2 then
    // we want the "modelica type"
    match ty case ET_COMPLEX(complexClassType=EXTERNAL_OBJ(__)) then
      'modelica_<%expTypeShort(ty)%>'
    else match ty case ET_COMPLEX(__) then
      'struct <%underscorePath(name)%>'
    else
      'modelica_<%expTypeShort(ty)%>'
  case 3 then
    // we want the "array type"
    '<%expTypeShort(ty)%>_array'
  case 4 then
    // we want the "array type" only if type is array, otherwise "modelica type"
    match ty
    case ET_ARRAY(__) then '<%expTypeShort(ty)%>_array'
    else expTypeFlag(ty, 2)
end expTypeFlag;


template expTypeFromExpFlag(Exp exp, Integer flag)
 "Generate type helper."
::=
  match exp
  case ICONST(__)        then match flag case 1 then "integer" else "modelica_integer"
  case RCONST(__)        then match flag case 1 then "real" else "modelica_real"
  case SCONST(__)        then match flag case 1 then "string" else "modelica_string"
  case BCONST(__)        then match flag case 1 then "boolean" else "modelica_boolean"
  case e as BINARY(__)
  case e as UNARY(__)
  case e as LBINARY(__)
  case e as LUNARY(__)
  case e as RELATION(__) then expTypeFromOpFlag(e.operator, flag)
  case IFEXP(__)         then expTypeFromExpFlag(expThen, flag)
  case CALL(__)          then expTypeFlag(ty, flag)
  case c as ARRAY(__)
  case c as MATRIX(__)
  case c as RANGE(__)
  case c as CAST(__)
  case c as CREF(__)
  case c as CODE(__)     then expTypeFlag(c.ty, flag)
  case ASUB(__)          then expTypeFromExpFlag(exp, flag)
  case REDUCTION(__)     then expTypeFromExpFlag(expr, flag)
  else "expTypeFromExpFlag:ERROR"
end expTypeFromExpFlag;


template expTypeFromOpFlag(Operator op, Integer flag)
 "Generate type helper."
::=
  match op
  case o as ADD(__)
  case o as SUB(__)
  case o as MUL(__)
  case o as DIV(__)
  case o as POW(__)
  case o as UMINUS(__)
  case o as UPLUS(__)
  case o as UMINUS_ARR(__)
  case o as UPLUS_ARR(__)
  case o as ADD_ARR(__)
  case o as SUB_ARR(__)
  case o as MUL_ARR(__)
  case o as DIV_ARR(__)
  case o as MUL_SCALAR_ARRAY(__)
  case o as MUL_ARRAY_SCALAR(__)
  case o as ADD_SCALAR_ARRAY(__)
  case o as ADD_ARRAY_SCALAR(__)
  case o as SUB_SCALAR_ARRAY(__)
  case o as SUB_ARRAY_SCALAR(__)
  case o as MUL_SCALAR_PRODUCT(__)
  case o as MUL_MATRIX_PRODUCT(__)
  case o as DIV_ARRAY_SCALAR(__)
  case o as DIV_SCALAR_ARRAY(__)
  case o as POW_ARRAY_SCALAR(__)
  case o as POW_SCALAR_ARRAY(__)
  case o as POW_ARR(__)
  case o as POW_ARR2(__)
  case o as LESS(__)
  case o as LESSEQ(__)
  case o as GREATER(__)
  case o as GREATEREQ(__)
  case o as EQUAL(__)
  case o as NEQUAL(__) then
    expTypeFlag(o.ty, flag)
  case o as AND(__)
  case o as OR(__)
  case o as NOT(__) then
    match flag case 1 then "boolean" else "modelica_boolean"
  else "expTypeFromOpFlag:ERROR"
end expTypeFromOpFlag;

template dimension(Dimension d)
::=
  match d
  case DAE.DIM_INTEGER(__) then integer
  case DAE.DIM_ENUM(__) then size
  case DAE.DIM_UNKNOWN(__) then ":"
  else "INVALID_DIMENSION"
end dimension;

end SimCodeC;

// vim: filetype=susan sw=2 sts=2
