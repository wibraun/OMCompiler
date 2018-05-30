// $ANTLR 3.2 Sep 23, 2009 12:02:23 src/org/openmodelica/corba/parser/OMCorbaDefinitions.g 2018-05-29 14:28:16
package org.openmodelica.corba.parser;import java.util.Vector;

import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

public class OMCorbaDefinitionsParser extends Parser {
    public static final String[] tokenNames = new String[] {
        "<invalid>", "<EOR>", "<DOWN>", "<UP>", "ID", "INT", "QID", "WS", "'('", "')'", "'package'", "'record'", "'metarecord'", "'extends'", "'function'", "'uniontype'", "'partial'", "'type'", "'replaceable'", "'['", "'input'", "'output'", "'Integer'", "'Real'", "'Boolean'", "'String'", "'list'", "'<'", "'>'", "'tuple'", "','", "'Option'"
    };
    public static final int INT=5;
    public static final int T__19=19;
    public static final int T__15=15;
    public static final int T__16=16;
    public static final int T__17=17;
    public static final int T__18=18;
    public static final int T__11=11;
    public static final int T__12=12;
    public static final int T__13=13;
    public static final int T__14=14;
    public static final int ID=4;
    public static final int WS=7;
    public static final int EOF=-1;
    public static final int T__30=30;
    public static final int T__31=31;
    public static final int T__10=10;
    public static final int T__9=9;
    public static final int T__8=8;
    public static final int QID=6;
    public static final int T__26=26;
    public static final int T__27=27;
    public static final int T__28=28;
    public static final int T__29=29;
    public static final int T__22=22;
    public static final int T__23=23;
    public static final int T__24=24;
    public static final int T__25=25;
    public static final int T__20=20;
    public static final int T__21=21;

    // delegates
    // delegators


        public OMCorbaDefinitionsParser(TokenStream input) {
            this(input, new RecognizerSharedState());
        }
        public OMCorbaDefinitionsParser(TokenStream input, RecognizerSharedState state) {
            super(input, state);

        }


    public String[] getTokenNames() { return OMCorbaDefinitionsParser.tokenNames; }
    public String getGrammarFileName() { return "src/org/openmodelica/corba/parser/OMCorbaDefinitions.g"; }


    public Vector<PackageDefinition> defs = new Vector<PackageDefinition>();
    public SymbolTable st = new SymbolTable();
    private Object memory;
    private String curPackage;
    protected Object recoverFromMismatchedToken(IntStream input, int ttype, BitSet follow) throws RecognitionException {
      MismatchedTokenException ex = new MismatchedTokenException(ttype, input);
      throw ex;
    }



    // $ANTLR start "definitions"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:23:1: definitions : '(' ( object )* ')' EOF ;
    public final void definitions() throws RecognitionException {
        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:23:13: ( '(' ( object )* ')' EOF )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:23:15: '(' ( object )* ')' EOF
            {
            this.curPackage = null; PackageDefinition pack = new PackageDefinition(null);
            match(input,8,FOLLOW_8_in_definitions63);
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:24:7: ( object )*
            loop1:
            do {
                int alt1=2;
                int LA1_0 = input.LA(1);

                if ( (LA1_0==8) ) {
                    alt1=1;
                }


                switch (alt1) {
            	case 1 :
            	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:24:8: object
            	    {
            	    pushFollow(FOLLOW_object_in_definitions66);
            	    object();

            	    state._fsp--;

            	    pack.add(memory);

            	    }
            	    break;

            	default :
            	    break loop1;
                }
            } while (true);

            match(input,9,FOLLOW_9_in_definitions72);
            match(input,EOF,FOLLOW_EOF_in_definitions74);
            defs.add(pack); memory = null; st.add(pack, null);

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "definitions"


    // $ANTLR start "object"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:26:1: object : ( package_ | record | function | uniontype | typedef | replaceable_type );
    public final void object() throws RecognitionException {
        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:26:8: ( package_ | record | function | uniontype | typedef | replaceable_type )
            int alt2=6;
            alt2 = dfa2.predict(input);
            switch (alt2) {
                case 1 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:26:10: package_
                    {
                    pushFollow(FOLLOW_package__in_object84);
                    package_();

                    state._fsp--;


                    }
                    break;
                case 2 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:26:21: record
                    {
                    pushFollow(FOLLOW_record_in_object88);
                    record();

                    state._fsp--;


                    }
                    break;
                case 3 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:26:30: function
                    {
                    pushFollow(FOLLOW_function_in_object92);
                    function();

                    state._fsp--;


                    }
                    break;
                case 4 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:26:41: uniontype
                    {
                    pushFollow(FOLLOW_uniontype_in_object96);
                    uniontype();

                    state._fsp--;


                    }
                    break;
                case 5 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:26:53: typedef
                    {
                    pushFollow(FOLLOW_typedef_in_object100);
                    typedef();

                    state._fsp--;


                    }
                    break;
                case 6 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:26:63: replaceable_type
                    {
                    pushFollow(FOLLOW_replaceable_type_in_object104);
                    replaceable_type();

                    state._fsp--;


                    }
                    break;

            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "object"


    // $ANTLR start "package_"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:28:1: package_ : '(' 'package' ID ( object )* ')' ;
    public final void package_() throws RecognitionException {
        Token ID1=null;

        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:28:10: ( '(' 'package' ID ( object )* ')' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:28:12: '(' 'package' ID ( object )* ')'
            {
            match(input,8,FOLLOW_8_in_package_112);
            match(input,10,FOLLOW_10_in_package_114);
            ID1=(Token)match(input,ID,FOLLOW_ID_in_package_116);
            String oldPackage = curPackage; curPackage = (curPackage != null ? curPackage + "." + (ID1!=null?ID1.getText():null) : (ID1!=null?ID1.getText():null)); PackageDefinition pack = new PackageDefinition(curPackage);
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:29:12: ( object )*
            loop3:
            do {
                int alt3=2;
                int LA3_0 = input.LA(1);

                if ( (LA3_0==8) ) {
                    alt3=1;
                }


                switch (alt3) {
            	case 1 :
            	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:29:13: object
            	    {
            	    pushFollow(FOLLOW_object_in_package_132);
            	    object();

            	    state._fsp--;

            	    pack.add(memory);

            	    }
            	    break;

            	default :
            	    break loop3;
                }
            } while (true);

            match(input,9,FOLLOW_9_in_package_138);
            defs.add(pack); memory = null; st.add(pack, null); curPackage = oldPackage;

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "package_"


    // $ANTLR start "record"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:30:1: record : ( '(' 'record' ID1= ID ( ( ( '(' varDef ')' ) | extends_ ) | object )* ')' | '(' 'metarecord' ID1= ID INT UT= ID ( ( ( '(' varDef ')' ) | extends_ ) | object )* ')' );
    public final void record() throws RecognitionException {
        Token ID1=null;
        Token UT=null;
        Token INT2=null;

        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:30:8: ( '(' 'record' ID1= ID ( ( ( '(' varDef ')' ) | extends_ ) | object )* ')' | '(' 'metarecord' ID1= ID INT UT= ID ( ( ( '(' varDef ')' ) | extends_ ) | object )* ')' )
            int alt8=2;
            int LA8_0 = input.LA(1);

            if ( (LA8_0==8) ) {
                int LA8_1 = input.LA(2);

                if ( (LA8_1==11) ) {
                    alt8=1;
                }
                else if ( (LA8_1==12) ) {
                    alt8=2;
                }
                else {
                    NoViableAltException nvae =
                        new NoViableAltException("", 8, 1, input);

                    throw nvae;
                }
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 8, 0, input);

                throw nvae;
            }
            switch (alt8) {
                case 1 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:30:10: '(' 'record' ID1= ID ( ( ( '(' varDef ')' ) | extends_ ) | object )* ')'
                    {
                    match(input,8,FOLLOW_8_in_record147);
                    match(input,11,FOLLOW_11_in_record149);
                    ID1=(Token)match(input,ID,FOLLOW_ID_in_record153);
                    String oldPackage = curPackage; curPackage = (curPackage != null ? curPackage + "." : "") + (ID1!=null?ID1.getText():null) ; RecordDefinition rec = new RecordDefinition((ID1!=null?ID1.getText():null), curPackage); PackageDefinition pack = new PackageDefinition(curPackage + ".inner");
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:31:10: ( ( ( '(' varDef ')' ) | extends_ ) | object )*
                    loop5:
                    do {
                        int alt5=3;
                        alt5 = dfa5.predict(input);
                        switch (alt5) {
                    	case 1 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:31:11: ( ( '(' varDef ')' ) | extends_ )
                    	    {
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:31:11: ( ( '(' varDef ')' ) | extends_ )
                    	    int alt4=2;
                    	    alt4 = dfa4.predict(input);
                    	    switch (alt4) {
                    	        case 1 :
                    	            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:31:12: ( '(' varDef ')' )
                    	            {
                    	            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:31:12: ( '(' varDef ')' )
                    	            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:31:13: '(' varDef ')'
                    	            {
                    	            match(input,8,FOLLOW_8_in_record169);
                    	            pushFollow(FOLLOW_varDef_in_record171);
                    	            varDef();

                    	            state._fsp--;

                    	            match(input,9,FOLLOW_9_in_record173);

                    	            }


                    	            }
                    	            break;
                    	        case 2 :
                    	            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:31:29: extends_
                    	            {
                    	            pushFollow(FOLLOW_extends__in_record176);
                    	            extends_();

                    	            state._fsp--;


                    	            }
                    	            break;

                    	    }

                    	    rec.fields.add(memory);

                    	    }
                    	    break;
                    	case 2 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:32:13: object
                    	    {
                    	    pushFollow(FOLLOW_object_in_record192);
                    	    object();

                    	    state._fsp--;

                    	    pack.add(memory);

                    	    }
                    	    break;

                    	default :
                    	    break loop5;
                        }
                    } while (true);

                    match(input,9,FOLLOW_9_in_record209);
                    memory = rec; curPackage = oldPackage; st.add(rec, curPackage);

                    }
                    break;
                case 2 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:34:11: '(' 'metarecord' ID1= ID INT UT= ID ( ( ( '(' varDef ')' ) | extends_ ) | object )* ')'
                    {
                    match(input,8,FOLLOW_8_in_record223);
                    match(input,12,FOLLOW_12_in_record225);
                    ID1=(Token)match(input,ID,FOLLOW_ID_in_record229);
                    String recID = (ID1!=null?ID1.getText():null); String oldPackage = curPackage; curPackage = (curPackage != null ? curPackage + "." : "") + (ID1!=null?ID1.getText():null) ; RecordDefinition rec; PackageDefinition pack = new PackageDefinition(curPackage + ".inner");
                    INT2=(Token)match(input,INT,FOLLOW_INT_in_record244);
                    int index = (INT2!=null?Integer.valueOf(INT2.getText()):0);
                    UT=(Token)match(input,ID,FOLLOW_ID_in_record261);
                    String uniontype = (UT!=null?UT.getText():null);
                    rec = new RecordDefinition(recID, uniontype, index, curPackage);
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:38:12: ( ( ( '(' varDef ')' ) | extends_ ) | object )*
                    loop7:
                    do {
                        int alt7=3;
                        alt7 = dfa7.predict(input);
                        switch (alt7) {
                    	case 1 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:38:13: ( ( '(' varDef ')' ) | extends_ )
                    	    {
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:38:13: ( ( '(' varDef ')' ) | extends_ )
                    	    int alt6=2;
                    	    alt6 = dfa6.predict(input);
                    	    switch (alt6) {
                    	        case 1 :
                    	            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:38:14: ( '(' varDef ')' )
                    	            {
                    	            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:38:14: ( '(' varDef ')' )
                    	            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:38:15: '(' varDef ')'
                    	            {
                    	            match(input,8,FOLLOW_8_in_record292);
                    	            pushFollow(FOLLOW_varDef_in_record294);
                    	            varDef();

                    	            state._fsp--;

                    	            match(input,9,FOLLOW_9_in_record296);

                    	            }


                    	            }
                    	            break;
                    	        case 2 :
                    	            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:38:31: extends_
                    	            {
                    	            pushFollow(FOLLOW_extends__in_record299);
                    	            extends_();

                    	            state._fsp--;


                    	            }
                    	            break;

                    	    }

                    	    rec.fields.add(memory);

                    	    }
                    	    break;
                    	case 2 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:39:15: object
                    	    {
                    	    pushFollow(FOLLOW_object_in_record317);
                    	    object();

                    	    state._fsp--;

                    	    pack.add(memory);

                    	    }
                    	    break;

                    	default :
                    	    break loop7;
                        }
                    } while (true);

                    match(input,9,FOLLOW_9_in_record336);
                    memory = rec; curPackage = oldPackage; st.add(rec, curPackage);

                    }
                    break;

            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "record"


    // $ANTLR start "extends_"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:41:1: extends_ : '(' 'extends' fqid ')' ;
    public final void extends_() throws RecognitionException {
        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:41:10: ( '(' 'extends' fqid ')' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:41:12: '(' 'extends' fqid ')'
            {
            match(input,8,FOLLOW_8_in_extends_345);
            match(input,13,FOLLOW_13_in_extends_347);
            pushFollow(FOLLOW_fqid_in_extends_349);
            fqid();

            state._fsp--;

            match(input,9,FOLLOW_9_in_extends_351);

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "extends_"


    // $ANTLR start "function"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:42:1: function : '(' 'function' ID ( input | output | object )* ')' ;
    public final void function() throws RecognitionException {
        Token ID3=null;

        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:42:10: ( '(' 'function' ID ( input | output | object )* ')' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:42:12: '(' 'function' ID ( input | output | object )* ')'
            {
            match(input,8,FOLLOW_8_in_function358);
            match(input,14,FOLLOW_14_in_function360);
            ID3=(Token)match(input,ID,FOLLOW_ID_in_function362);
            FunctionDefinition fun = new FunctionDefinition((ID3!=null?ID3.getText():null)); String oldPackage = curPackage; curPackage = (curPackage != null ? curPackage + "." : "") + (ID3!=null?ID3.getText():null); PackageDefinition pack = new PackageDefinition(curPackage + ".inner");
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:43:13: ( input | output | object )*
            loop9:
            do {
                int alt9=4;
                alt9 = dfa9.predict(input);
                switch (alt9) {
            	case 1 :
            	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:43:15: input
            	    {
            	    pushFollow(FOLLOW_input_in_function380);
            	    input();

            	    state._fsp--;

            	    fun.input.add((VariableDefinition)memory);

            	    }
            	    break;
            	case 2 :
            	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:44:15: output
            	    {
            	    pushFollow(FOLLOW_output_in_function397);
            	    output();

            	    state._fsp--;

            	    fun.output.add((VariableDefinition)memory);

            	    }
            	    break;
            	case 3 :
            	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:45:15: object
            	    {
            	    pushFollow(FOLLOW_object_in_function414);
            	    object();

            	    state._fsp--;

            	    pack.add(memory);

            	    }
            	    break;

            	default :
            	    break loop9;
                }
            } while (true);

            match(input,9,FOLLOW_9_in_function445);
            curPackage = oldPackage; memory = fun; st.add(fun, curPackage);

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "function"


    // $ANTLR start "uniontype"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:48:1: uniontype : '(' 'uniontype' ID ')' ;
    public final void uniontype() throws RecognitionException {
        Token ID4=null;

        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:48:11: ( '(' 'uniontype' ID ')' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:48:13: '(' 'uniontype' ID ')'
            {
            match(input,8,FOLLOW_8_in_uniontype454);
            match(input,15,FOLLOW_15_in_uniontype456);
            ID4=(Token)match(input,ID,FOLLOW_ID_in_uniontype458);
            match(input,9,FOLLOW_9_in_uniontype460);
            UniontypeDefinition union = new UniontypeDefinition((ID4!=null?ID4.getText():null)); memory = union; st.add(union, curPackage);

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "uniontype"


    // $ANTLR start "typedef"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:49:1: typedef : ( '(' 'partial' 'function' ID ')' | '(' 'type' ID type ')' );
    public final void typedef() throws RecognitionException {
        Token ID5=null;
        Token ID6=null;

        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:49:9: ( '(' 'partial' 'function' ID ')' | '(' 'type' ID type ')' )
            int alt10=2;
            int LA10_0 = input.LA(1);

            if ( (LA10_0==8) ) {
                int LA10_1 = input.LA(2);

                if ( (LA10_1==16) ) {
                    alt10=1;
                }
                else if ( (LA10_1==17) ) {
                    alt10=2;
                }
                else {
                    NoViableAltException nvae =
                        new NoViableAltException("", 10, 1, input);

                    throw nvae;
                }
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 10, 0, input);

                throw nvae;
            }
            switch (alt10) {
                case 1 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:49:11: '(' 'partial' 'function' ID ')'
                    {
                    match(input,8,FOLLOW_8_in_typedef469);
                    match(input,16,FOLLOW_16_in_typedef471);
                    match(input,14,FOLLOW_14_in_typedef473);
                    ID5=(Token)match(input,ID,FOLLOW_ID_in_typedef475);
                    match(input,9,FOLLOW_9_in_typedef477);
                    memory = new VariableDefinition(new ComplexTypeDefinition(ComplexTypeDefinition.ComplexType.FUNCTION_REFERENCE), (ID5!=null?ID5.getText():null), curPackage);st.add((VariableDefinition)memory, curPackage);

                    }
                    break;
                case 2 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:50:11: '(' 'type' ID type ')'
                    {
                    match(input,8,FOLLOW_8_in_typedef491);
                    match(input,17,FOLLOW_17_in_typedef493);
                    ID6=(Token)match(input,ID,FOLLOW_ID_in_typedef495);
                    pushFollow(FOLLOW_type_in_typedef497);
                    type();

                    state._fsp--;

                    match(input,9,FOLLOW_9_in_typedef499);
                    memory = new VariableDefinition((ComplexTypeDefinition) memory, (ID6!=null?ID6.getText():null), curPackage); st.add((VariableDefinition)memory, curPackage);

                    }
                    break;

            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "typedef"


    // $ANTLR start "replaceable_type"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:52:1: replaceable_type : '(' 'replaceable' 'type' ID ')' ;
    public final void replaceable_type() throws RecognitionException {
        Token ID7=null;

        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:52:18: ( '(' 'replaceable' 'type' ID ')' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:52:20: '(' 'replaceable' 'type' ID ')'
            {
            match(input,8,FOLLOW_8_in_replaceable_type509);
            match(input,18,FOLLOW_18_in_replaceable_type511);
            match(input,17,FOLLOW_17_in_replaceable_type513);
            ID7=(Token)match(input,ID,FOLLOW_ID_in_replaceable_type515);
            match(input,9,FOLLOW_9_in_replaceable_type517);
            memory = new VariableDefinition(new ComplexTypeDefinition(ComplexTypeDefinition.ComplexType.GENERIC_TYPE, "ModelicaObject"), (ID7!=null?ID7.getText():null), curPackage); st.add((VariableDefinition)memory, curPackage);

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "replaceable_type"


    // $ANTLR start "type"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:54:1: type : ( basetype | complextype | '[' INT type | fqid );
    public final void type() throws RecognitionException {
        Token INT8=null;

        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:54:6: ( basetype | complextype | '[' INT type | fqid )
            int alt11=4;
            alt11 = dfa11.predict(input);
            switch (alt11) {
                case 1 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:54:8: basetype
                    {
                    pushFollow(FOLLOW_basetype_in_type527);
                    basetype();

                    state._fsp--;


                    }
                    break;
                case 2 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:55:8: complextype
                    {
                    pushFollow(FOLLOW_complextype_in_type536);
                    complextype();

                    state._fsp--;


                    }
                    break;
                case 3 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:56:8: '[' INT type
                    {
                    match(input,19,FOLLOW_19_in_type545);
                    INT8=(Token)match(input,INT,FOLLOW_INT_in_type547);
                    pushFollow(FOLLOW_type_in_type549);
                    type();

                    state._fsp--;

                    memory = new ComplexTypeDefinition(ComplexTypeDefinition.ComplexType.ARRAY, (ComplexTypeDefinition) memory, (INT8!=null?Integer.valueOf(INT8.getText()):0));

                    }
                    break;
                case 4 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:57:8: fqid
                    {
                    pushFollow(FOLLOW_fqid_in_type560);
                    fqid();

                    state._fsp--;

                    memory = new ComplexTypeDefinition(ComplexTypeDefinition.ComplexType.DEFINED_TYPE, (String) memory);

                    }
                    break;

            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "type"


    // $ANTLR start "varDef"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:58:1: varDef : type ID ;
    public final void varDef() throws RecognitionException {
        Token ID9=null;

        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:58:8: ( type ID )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:58:10: type ID
            {
            pushFollow(FOLLOW_type_in_varDef569);
            type();

            state._fsp--;

            ID9=(Token)match(input,ID,FOLLOW_ID_in_varDef571);
            memory = new VariableDefinition((ComplexTypeDefinition)memory, (ID9!=null?ID9.getText():null), curPackage);

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "varDef"


    // $ANTLR start "input"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:59:1: input : '(' 'input' varDef ')' ;
    public final void input() throws RecognitionException {
        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:59:8: ( '(' 'input' varDef ')' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:59:10: '(' 'input' varDef ')'
            {
            match(input,8,FOLLOW_8_in_input581);
            match(input,20,FOLLOW_20_in_input583);
            pushFollow(FOLLOW_varDef_in_input585);
            varDef();

            state._fsp--;

            match(input,9,FOLLOW_9_in_input587);

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "input"


    // $ANTLR start "output"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:60:1: output : '(' 'output' varDef ')' ;
    public final void output() throws RecognitionException {
        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:60:8: ( '(' 'output' varDef ')' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:60:10: '(' 'output' varDef ')'
            {
            match(input,8,FOLLOW_8_in_output594);
            match(input,21,FOLLOW_21_in_output596);
            pushFollow(FOLLOW_varDef_in_output598);
            varDef();

            state._fsp--;

            match(input,9,FOLLOW_9_in_output600);

            }

        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "output"


    // $ANTLR start "basetype"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:61:1: basetype : ( 'Integer' | 'Real' | 'Boolean' | 'String' );
    public final void basetype() throws RecognitionException {
        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:61:10: ( 'Integer' | 'Real' | 'Boolean' | 'String' )
            int alt12=4;
            switch ( input.LA(1) ) {
            case 22:
                {
                alt12=1;
                }
                break;
            case 23:
                {
                alt12=2;
                }
                break;
            case 24:
                {
                alt12=3;
                }
                break;
            case 25:
                {
                alt12=4;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 12, 0, input);

                throw nvae;
            }

            switch (alt12) {
                case 1 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:61:12: 'Integer'
                    {
                    match(input,22,FOLLOW_22_in_basetype607);
                    memory = new ComplexTypeDefinition(ComplexTypeDefinition.ComplexType.BUILT_IN, "ModelicaInteger");

                    }
                    break;
                case 2 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:62:12: 'Real'
                    {
                    match(input,23,FOLLOW_23_in_basetype622);
                    memory = new ComplexTypeDefinition(ComplexTypeDefinition.ComplexType.BUILT_IN, "ModelicaReal");

                    }
                    break;
                case 3 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:63:12: 'Boolean'
                    {
                    match(input,24,FOLLOW_24_in_basetype637);
                    memory = new ComplexTypeDefinition(ComplexTypeDefinition.ComplexType.BUILT_IN, "ModelicaBoolean");

                    }
                    break;
                case 4 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:64:12: 'String'
                    {
                    match(input,25,FOLLOW_25_in_basetype652);
                    memory = new ComplexTypeDefinition(ComplexTypeDefinition.ComplexType.BUILT_IN, "ModelicaString");

                    }
                    break;

            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "basetype"


    // $ANTLR start "complextype"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:65:1: complextype : ( ( 'list' ) '<' type '>' | ( 'tuple' ) '<' type ( ',' type )+ '>' | ( 'Option' ) '<' type '>' );
    public final void complextype() throws RecognitionException {
        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:65:13: ( ( 'list' ) '<' type '>' | ( 'tuple' ) '<' type ( ',' type )+ '>' | ( 'Option' ) '<' type '>' )
            int alt14=3;
            switch ( input.LA(1) ) {
            case 26:
                {
                alt14=1;
                }
                break;
            case 29:
                {
                alt14=2;
                }
                break;
            case 31:
                {
                alt14=3;
                }
                break;
            default:
                NoViableAltException nvae =
                    new NoViableAltException("", 14, 0, input);

                throw nvae;
            }

            switch (alt14) {
                case 1 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:66:8: ( 'list' ) '<' type '>'
                    {
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:66:8: ( 'list' )
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:66:9: 'list'
                    {
                    match(input,26,FOLLOW_26_in_complextype672);

                    }

                    ComplexTypeDefinition def = new ComplexTypeDefinition(ComplexTypeDefinition.ComplexType.LIST_TYPE);
                    match(input,27,FOLLOW_27_in_complextype684);
                    pushFollow(FOLLOW_type_in_complextype686);
                    type();

                    state._fsp--;

                    def.add((ComplexTypeDefinition)memory);
                    match(input,28,FOLLOW_28_in_complextype690);
                    memory = def;

                    }
                    break;
                case 2 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:68:8: ( 'tuple' ) '<' type ( ',' type )+ '>'
                    {
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:68:8: ( 'tuple' )
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:68:9: 'tuple'
                    {
                    match(input,29,FOLLOW_29_in_complextype702);

                    }

                    ComplexTypeDefinition def = new ComplexTypeDefinition(ComplexTypeDefinition.ComplexType.TUPLE_TYPE);
                    match(input,27,FOLLOW_27_in_complextype714);
                    pushFollow(FOLLOW_type_in_complextype716);
                    type();

                    state._fsp--;

                    def.add((ComplexTypeDefinition)memory);
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:69:59: ( ',' type )+
                    int cnt13=0;
                    loop13:
                    do {
                        int alt13=2;
                        int LA13_0 = input.LA(1);

                        if ( (LA13_0==30) ) {
                            alt13=1;
                        }


                        switch (alt13) {
                    	case 1 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:69:60: ',' type
                    	    {
                    	    match(input,30,FOLLOW_30_in_complextype721);
                    	    pushFollow(FOLLOW_type_in_complextype723);
                    	    type();

                    	    state._fsp--;

                    	    def.add((ComplexTypeDefinition)memory);

                    	    }
                    	    break;

                    	default :
                    	    if ( cnt13 >= 1 ) break loop13;
                                EarlyExitException eee =
                                    new EarlyExitException(13, input);
                                throw eee;
                        }
                        cnt13++;
                    } while (true);

                    match(input,28,FOLLOW_28_in_complextype729);
                    memory = def;

                    }
                    break;
                case 3 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:70:8: ( 'Option' ) '<' type '>'
                    {
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:70:8: ( 'Option' )
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:70:9: 'Option'
                    {
                    match(input,31,FOLLOW_31_in_complextype741);

                    }

                    ComplexTypeDefinition def = new ComplexTypeDefinition(ComplexTypeDefinition.ComplexType.OPTION_TYPE);
                    match(input,27,FOLLOW_27_in_complextype753);
                    pushFollow(FOLLOW_type_in_complextype755);
                    type();

                    state._fsp--;

                    def.add((ComplexTypeDefinition)memory);
                    match(input,28,FOLLOW_28_in_complextype759);
                    memory = def;

                    }
                    break;

            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "complextype"


    // $ANTLR start "fqid"
    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:72:1: fqid : ( ID | QID );
    public final void fqid() throws RecognitionException {
        Token ID10=null;
        Token QID11=null;

        try {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:72:6: ( ID | QID )
            int alt15=2;
            int LA15_0 = input.LA(1);

            if ( (LA15_0==ID) ) {
                alt15=1;
            }
            else if ( (LA15_0==QID) ) {
                alt15=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 15, 0, input);

                throw nvae;
            }
            switch (alt15) {
                case 1 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:72:8: ID
                    {
                    ID10=(Token)match(input,ID,FOLLOW_ID_in_fqid768);
                    memory = (ID10!=null?ID10.getText():null);

                    }
                    break;
                case 2 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:73:8: QID
                    {
                    QID11=(Token)match(input,QID,FOLLOW_QID_in_fqid779);
                    memory = (QID11!=null?QID11.getText():null);

                    }
                    break;

            }
        }
        catch (RecognitionException re) {
            reportError(re);
            recover(input,re);
        }
        finally {
        }
        return ;
    }
    // $ANTLR end "fqid"

    // Delegated rules


    protected DFA2 dfa2 = new DFA2(this);
    protected DFA5 dfa5 = new DFA5(this);
    protected DFA4 dfa4 = new DFA4(this);
    protected DFA7 dfa7 = new DFA7(this);
    protected DFA6 dfa6 = new DFA6(this);
    protected DFA9 dfa9 = new DFA9(this);
    protected DFA11 dfa11 = new DFA11(this);
    static final String DFA2_eotS =
        "\12\uffff";
    static final String DFA2_eofS =
        "\12\uffff";
    static final String DFA2_minS =
        "\1\10\1\12\10\uffff";
    static final String DFA2_maxS =
        "\1\10\1\22\10\uffff";
    static final String DFA2_acceptS =
        "\2\uffff\1\1\1\2\1\uffff\1\3\1\4\1\5\1\uffff\1\6";
    static final String DFA2_specialS =
        "\12\uffff}>";
    static final String[] DFA2_transitionS = {
            "\1\1",
            "\1\2\2\3\1\uffff\1\5\1\6\2\7\1\11",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
    };

    static final short[] DFA2_eot = DFA.unpackEncodedString(DFA2_eotS);
    static final short[] DFA2_eof = DFA.unpackEncodedString(DFA2_eofS);
    static final char[] DFA2_min = DFA.unpackEncodedStringToUnsignedChars(DFA2_minS);
    static final char[] DFA2_max = DFA.unpackEncodedStringToUnsignedChars(DFA2_maxS);
    static final short[] DFA2_accept = DFA.unpackEncodedString(DFA2_acceptS);
    static final short[] DFA2_special = DFA.unpackEncodedString(DFA2_specialS);
    static final short[][] DFA2_transition;

    static {
        int numStates = DFA2_transitionS.length;
        DFA2_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA2_transition[i] = DFA.unpackEncodedString(DFA2_transitionS[i]);
        }
    }

    class DFA2 extends DFA {

        public DFA2(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 2;
            this.eot = DFA2_eot;
            this.eof = DFA2_eof;
            this.min = DFA2_min;
            this.max = DFA2_max;
            this.accept = DFA2_accept;
            this.special = DFA2_special;
            this.transition = DFA2_transition;
        }
        public String getDescription() {
            return "26:1: object : ( package_ | record | function | uniontype | typedef | replaceable_type );";
        }
    }
    static final String DFA5_eotS =
        "\26\uffff";
    static final String DFA5_eofS =
        "\26\uffff";
    static final String DFA5_minS =
        "\1\10\1\uffff\1\4\23\uffff";
    static final String DFA5_maxS =
        "\1\11\1\uffff\1\37\23\uffff";
    static final String DFA5_acceptS =
        "\1\uffff\1\3\1\uffff\1\1\1\2\21\uffff";
    static final String DFA5_specialS =
        "\26\uffff}>";
    static final String[] DFA5_transitionS = {
            "\1\2\1\1",
            "",
            "\1\3\1\uffff\1\3\3\uffff\3\4\1\3\5\4\1\3\2\uffff\5\3\2\uffff"+
            "\1\3\1\uffff\1\3",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
    };

    static final short[] DFA5_eot = DFA.unpackEncodedString(DFA5_eotS);
    static final short[] DFA5_eof = DFA.unpackEncodedString(DFA5_eofS);
    static final char[] DFA5_min = DFA.unpackEncodedStringToUnsignedChars(DFA5_minS);
    static final char[] DFA5_max = DFA.unpackEncodedStringToUnsignedChars(DFA5_maxS);
    static final short[] DFA5_accept = DFA.unpackEncodedString(DFA5_acceptS);
    static final short[] DFA5_special = DFA.unpackEncodedString(DFA5_specialS);
    static final short[][] DFA5_transition;

    static {
        int numStates = DFA5_transitionS.length;
        DFA5_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA5_transition[i] = DFA.unpackEncodedString(DFA5_transitionS[i]);
        }
    }

    class DFA5 extends DFA {

        public DFA5(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 5;
            this.eot = DFA5_eot;
            this.eof = DFA5_eof;
            this.min = DFA5_min;
            this.max = DFA5_max;
            this.accept = DFA5_accept;
            this.special = DFA5_special;
            this.transition = DFA5_transition;
        }
        public String getDescription() {
            return "()* loopback of 31:10: ( ( ( '(' varDef ')' ) | extends_ ) | object )*";
        }
    }
    static final String DFA4_eotS =
        "\15\uffff";
    static final String DFA4_eofS =
        "\15\uffff";
    static final String DFA4_minS =
        "\1\10\1\4\13\uffff";
    static final String DFA4_maxS =
        "\1\10\1\37\13\uffff";
    static final String DFA4_acceptS =
        "\2\uffff\1\2\1\1\11\uffff";
    static final String DFA4_specialS =
        "\15\uffff}>";
    static final String[] DFA4_transitionS = {
            "\1\1",
            "\1\3\1\uffff\1\3\6\uffff\1\2\5\uffff\1\3\2\uffff\5\3\2\uffff"+
            "\1\3\1\uffff\1\3",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
    };

    static final short[] DFA4_eot = DFA.unpackEncodedString(DFA4_eotS);
    static final short[] DFA4_eof = DFA.unpackEncodedString(DFA4_eofS);
    static final char[] DFA4_min = DFA.unpackEncodedStringToUnsignedChars(DFA4_minS);
    static final char[] DFA4_max = DFA.unpackEncodedStringToUnsignedChars(DFA4_maxS);
    static final short[] DFA4_accept = DFA.unpackEncodedString(DFA4_acceptS);
    static final short[] DFA4_special = DFA.unpackEncodedString(DFA4_specialS);
    static final short[][] DFA4_transition;

    static {
        int numStates = DFA4_transitionS.length;
        DFA4_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA4_transition[i] = DFA.unpackEncodedString(DFA4_transitionS[i]);
        }
    }

    class DFA4 extends DFA {

        public DFA4(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 4;
            this.eot = DFA4_eot;
            this.eof = DFA4_eof;
            this.min = DFA4_min;
            this.max = DFA4_max;
            this.accept = DFA4_accept;
            this.special = DFA4_special;
            this.transition = DFA4_transition;
        }
        public String getDescription() {
            return "31:11: ( ( '(' varDef ')' ) | extends_ )";
        }
    }
    static final String DFA7_eotS =
        "\26\uffff";
    static final String DFA7_eofS =
        "\26\uffff";
    static final String DFA7_minS =
        "\1\10\1\uffff\1\4\23\uffff";
    static final String DFA7_maxS =
        "\1\11\1\uffff\1\37\23\uffff";
    static final String DFA7_acceptS =
        "\1\uffff\1\3\1\uffff\1\1\1\2\21\uffff";
    static final String DFA7_specialS =
        "\26\uffff}>";
    static final String[] DFA7_transitionS = {
            "\1\2\1\1",
            "",
            "\1\3\1\uffff\1\3\3\uffff\3\4\1\3\5\4\1\3\2\uffff\5\3\2\uffff"+
            "\1\3\1\uffff\1\3",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
    };

    static final short[] DFA7_eot = DFA.unpackEncodedString(DFA7_eotS);
    static final short[] DFA7_eof = DFA.unpackEncodedString(DFA7_eofS);
    static final char[] DFA7_min = DFA.unpackEncodedStringToUnsignedChars(DFA7_minS);
    static final char[] DFA7_max = DFA.unpackEncodedStringToUnsignedChars(DFA7_maxS);
    static final short[] DFA7_accept = DFA.unpackEncodedString(DFA7_acceptS);
    static final short[] DFA7_special = DFA.unpackEncodedString(DFA7_specialS);
    static final short[][] DFA7_transition;

    static {
        int numStates = DFA7_transitionS.length;
        DFA7_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA7_transition[i] = DFA.unpackEncodedString(DFA7_transitionS[i]);
        }
    }

    class DFA7 extends DFA {

        public DFA7(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 7;
            this.eot = DFA7_eot;
            this.eof = DFA7_eof;
            this.min = DFA7_min;
            this.max = DFA7_max;
            this.accept = DFA7_accept;
            this.special = DFA7_special;
            this.transition = DFA7_transition;
        }
        public String getDescription() {
            return "()* loopback of 38:12: ( ( ( '(' varDef ')' ) | extends_ ) | object )*";
        }
    }
    static final String DFA6_eotS =
        "\15\uffff";
    static final String DFA6_eofS =
        "\15\uffff";
    static final String DFA6_minS =
        "\1\10\1\4\13\uffff";
    static final String DFA6_maxS =
        "\1\10\1\37\13\uffff";
    static final String DFA6_acceptS =
        "\2\uffff\1\2\1\1\11\uffff";
    static final String DFA6_specialS =
        "\15\uffff}>";
    static final String[] DFA6_transitionS = {
            "\1\1",
            "\1\3\1\uffff\1\3\6\uffff\1\2\5\uffff\1\3\2\uffff\5\3\2\uffff"+
            "\1\3\1\uffff\1\3",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
    };

    static final short[] DFA6_eot = DFA.unpackEncodedString(DFA6_eotS);
    static final short[] DFA6_eof = DFA.unpackEncodedString(DFA6_eofS);
    static final char[] DFA6_min = DFA.unpackEncodedStringToUnsignedChars(DFA6_minS);
    static final char[] DFA6_max = DFA.unpackEncodedStringToUnsignedChars(DFA6_maxS);
    static final short[] DFA6_accept = DFA.unpackEncodedString(DFA6_acceptS);
    static final short[] DFA6_special = DFA.unpackEncodedString(DFA6_specialS);
    static final short[][] DFA6_transition;

    static {
        int numStates = DFA6_transitionS.length;
        DFA6_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA6_transition[i] = DFA.unpackEncodedString(DFA6_transitionS[i]);
        }
    }

    class DFA6 extends DFA {

        public DFA6(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 6;
            this.eot = DFA6_eot;
            this.eof = DFA6_eof;
            this.min = DFA6_min;
            this.max = DFA6_max;
            this.accept = DFA6_accept;
            this.special = DFA6_special;
            this.transition = DFA6_transition;
        }
        public String getDescription() {
            return "38:13: ( ( '(' varDef ')' ) | extends_ )";
        }
    }
    static final String DFA9_eotS =
        "\15\uffff";
    static final String DFA9_eofS =
        "\15\uffff";
    static final String DFA9_minS =
        "\1\10\1\uffff\1\12\12\uffff";
    static final String DFA9_maxS =
        "\1\11\1\uffff\1\25\12\uffff";
    static final String DFA9_acceptS =
        "\1\uffff\1\4\1\uffff\1\1\1\2\1\3\7\uffff";
    static final String DFA9_specialS =
        "\15\uffff}>";
    static final String[] DFA9_transitionS = {
            "\1\2\1\1",
            "",
            "\3\5\1\uffff\5\5\1\uffff\1\3\1\4",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
    };

    static final short[] DFA9_eot = DFA.unpackEncodedString(DFA9_eotS);
    static final short[] DFA9_eof = DFA.unpackEncodedString(DFA9_eofS);
    static final char[] DFA9_min = DFA.unpackEncodedStringToUnsignedChars(DFA9_minS);
    static final char[] DFA9_max = DFA.unpackEncodedStringToUnsignedChars(DFA9_maxS);
    static final short[] DFA9_accept = DFA.unpackEncodedString(DFA9_acceptS);
    static final short[] DFA9_special = DFA.unpackEncodedString(DFA9_specialS);
    static final short[][] DFA9_transition;

    static {
        int numStates = DFA9_transitionS.length;
        DFA9_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA9_transition[i] = DFA.unpackEncodedString(DFA9_transitionS[i]);
        }
    }

    class DFA9 extends DFA {

        public DFA9(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 9;
            this.eot = DFA9_eot;
            this.eof = DFA9_eof;
            this.min = DFA9_min;
            this.max = DFA9_max;
            this.accept = DFA9_accept;
            this.special = DFA9_special;
            this.transition = DFA9_transition;
        }
        public String getDescription() {
            return "()* loopback of 43:13: ( input | output | object )*";
        }
    }
    static final String DFA11_eotS =
        "\13\uffff";
    static final String DFA11_eofS =
        "\13\uffff";
    static final String DFA11_minS =
        "\1\4\12\uffff";
    static final String DFA11_maxS =
        "\1\37\12\uffff";
    static final String DFA11_acceptS =
        "\1\uffff\1\1\3\uffff\1\2\2\uffff\1\3\1\4\1\uffff";
    static final String DFA11_specialS =
        "\13\uffff}>";
    static final String[] DFA11_transitionS = {
            "\1\11\1\uffff\1\11\14\uffff\1\10\2\uffff\4\1\1\5\2\uffff\1\5"+
            "\1\uffff\1\5",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
    };

    static final short[] DFA11_eot = DFA.unpackEncodedString(DFA11_eotS);
    static final short[] DFA11_eof = DFA.unpackEncodedString(DFA11_eofS);
    static final char[] DFA11_min = DFA.unpackEncodedStringToUnsignedChars(DFA11_minS);
    static final char[] DFA11_max = DFA.unpackEncodedStringToUnsignedChars(DFA11_maxS);
    static final short[] DFA11_accept = DFA.unpackEncodedString(DFA11_acceptS);
    static final short[] DFA11_special = DFA.unpackEncodedString(DFA11_specialS);
    static final short[][] DFA11_transition;

    static {
        int numStates = DFA11_transitionS.length;
        DFA11_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA11_transition[i] = DFA.unpackEncodedString(DFA11_transitionS[i]);
        }
    }

    class DFA11 extends DFA {

        public DFA11(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 11;
            this.eot = DFA11_eot;
            this.eof = DFA11_eof;
            this.min = DFA11_min;
            this.max = DFA11_max;
            this.accept = DFA11_accept;
            this.special = DFA11_special;
            this.transition = DFA11_transition;
        }
        public String getDescription() {
            return "54:1: type : ( basetype | complextype | '[' INT type | fqid );";
        }
    }


    public static final BitSet FOLLOW_8_in_definitions63 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_object_in_definitions66 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_9_in_definitions72 = new BitSet(new long[]{0x0000000000000000L});
    public static final BitSet FOLLOW_EOF_in_definitions74 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_package__in_object84 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_record_in_object88 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_function_in_object92 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_uniontype_in_object96 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_typedef_in_object100 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_replaceable_type_in_object104 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_8_in_package_112 = new BitSet(new long[]{0x0000000000000400L});
    public static final BitSet FOLLOW_10_in_package_114 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_ID_in_package_116 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_object_in_package_132 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_9_in_package_138 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_8_in_record147 = new BitSet(new long[]{0x0000000000000800L});
    public static final BitSet FOLLOW_11_in_record149 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_ID_in_record153 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_8_in_record169 = new BitSet(new long[]{0x00000000A7C80050L});
    public static final BitSet FOLLOW_varDef_in_record171 = new BitSet(new long[]{0x0000000000000200L});
    public static final BitSet FOLLOW_9_in_record173 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_extends__in_record176 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_object_in_record192 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_9_in_record209 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_8_in_record223 = new BitSet(new long[]{0x0000000000001000L});
    public static final BitSet FOLLOW_12_in_record225 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_ID_in_record229 = new BitSet(new long[]{0x0000000000000020L});
    public static final BitSet FOLLOW_INT_in_record244 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_ID_in_record261 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_8_in_record292 = new BitSet(new long[]{0x00000000A7C80050L});
    public static final BitSet FOLLOW_varDef_in_record294 = new BitSet(new long[]{0x0000000000000200L});
    public static final BitSet FOLLOW_9_in_record296 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_extends__in_record299 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_object_in_record317 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_9_in_record336 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_8_in_extends_345 = new BitSet(new long[]{0x0000000000002000L});
    public static final BitSet FOLLOW_13_in_extends_347 = new BitSet(new long[]{0x00000000A7C80050L});
    public static final BitSet FOLLOW_fqid_in_extends_349 = new BitSet(new long[]{0x0000000000000200L});
    public static final BitSet FOLLOW_9_in_extends_351 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_8_in_function358 = new BitSet(new long[]{0x0000000000004000L});
    public static final BitSet FOLLOW_14_in_function360 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_ID_in_function362 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_input_in_function380 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_output_in_function397 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_object_in_function414 = new BitSet(new long[]{0x0000000000000300L});
    public static final BitSet FOLLOW_9_in_function445 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_8_in_uniontype454 = new BitSet(new long[]{0x0000000000008000L});
    public static final BitSet FOLLOW_15_in_uniontype456 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_ID_in_uniontype458 = new BitSet(new long[]{0x0000000000000200L});
    public static final BitSet FOLLOW_9_in_uniontype460 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_8_in_typedef469 = new BitSet(new long[]{0x0000000000010000L});
    public static final BitSet FOLLOW_16_in_typedef471 = new BitSet(new long[]{0x0000000000004000L});
    public static final BitSet FOLLOW_14_in_typedef473 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_ID_in_typedef475 = new BitSet(new long[]{0x0000000000000200L});
    public static final BitSet FOLLOW_9_in_typedef477 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_8_in_typedef491 = new BitSet(new long[]{0x0000000000020000L});
    public static final BitSet FOLLOW_17_in_typedef493 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_ID_in_typedef495 = new BitSet(new long[]{0x00000000A7C80050L});
    public static final BitSet FOLLOW_type_in_typedef497 = new BitSet(new long[]{0x0000000000000200L});
    public static final BitSet FOLLOW_9_in_typedef499 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_8_in_replaceable_type509 = new BitSet(new long[]{0x0000000000040000L});
    public static final BitSet FOLLOW_18_in_replaceable_type511 = new BitSet(new long[]{0x0000000000020000L});
    public static final BitSet FOLLOW_17_in_replaceable_type513 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_ID_in_replaceable_type515 = new BitSet(new long[]{0x0000000000000200L});
    public static final BitSet FOLLOW_9_in_replaceable_type517 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_basetype_in_type527 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_complextype_in_type536 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_19_in_type545 = new BitSet(new long[]{0x0000000000000020L});
    public static final BitSet FOLLOW_INT_in_type547 = new BitSet(new long[]{0x00000000A7C80050L});
    public static final BitSet FOLLOW_type_in_type549 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_fqid_in_type560 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_type_in_varDef569 = new BitSet(new long[]{0x0000000000000010L});
    public static final BitSet FOLLOW_ID_in_varDef571 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_8_in_input581 = new BitSet(new long[]{0x0000000000100000L});
    public static final BitSet FOLLOW_20_in_input583 = new BitSet(new long[]{0x00000000A7C80050L});
    public static final BitSet FOLLOW_varDef_in_input585 = new BitSet(new long[]{0x0000000000000200L});
    public static final BitSet FOLLOW_9_in_input587 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_8_in_output594 = new BitSet(new long[]{0x0000000000200000L});
    public static final BitSet FOLLOW_21_in_output596 = new BitSet(new long[]{0x00000000A7C80050L});
    public static final BitSet FOLLOW_varDef_in_output598 = new BitSet(new long[]{0x0000000000000200L});
    public static final BitSet FOLLOW_9_in_output600 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_22_in_basetype607 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_23_in_basetype622 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_24_in_basetype637 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_25_in_basetype652 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_26_in_complextype672 = new BitSet(new long[]{0x0000000008000000L});
    public static final BitSet FOLLOW_27_in_complextype684 = new BitSet(new long[]{0x00000000A7C80050L});
    public static final BitSet FOLLOW_type_in_complextype686 = new BitSet(new long[]{0x0000000010000000L});
    public static final BitSet FOLLOW_28_in_complextype690 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_29_in_complextype702 = new BitSet(new long[]{0x0000000008000000L});
    public static final BitSet FOLLOW_27_in_complextype714 = new BitSet(new long[]{0x00000000A7C80050L});
    public static final BitSet FOLLOW_type_in_complextype716 = new BitSet(new long[]{0x0000000040000000L});
    public static final BitSet FOLLOW_30_in_complextype721 = new BitSet(new long[]{0x00000000A7C80050L});
    public static final BitSet FOLLOW_type_in_complextype723 = new BitSet(new long[]{0x0000000050000000L});
    public static final BitSet FOLLOW_28_in_complextype729 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_31_in_complextype741 = new BitSet(new long[]{0x0000000008000000L});
    public static final BitSet FOLLOW_27_in_complextype753 = new BitSet(new long[]{0x00000000A7C80050L});
    public static final BitSet FOLLOW_type_in_complextype755 = new BitSet(new long[]{0x0000000010000000L});
    public static final BitSet FOLLOW_28_in_complextype759 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_ID_in_fqid768 = new BitSet(new long[]{0x0000000000000002L});
    public static final BitSet FOLLOW_QID_in_fqid779 = new BitSet(new long[]{0x0000000000000002L});

}