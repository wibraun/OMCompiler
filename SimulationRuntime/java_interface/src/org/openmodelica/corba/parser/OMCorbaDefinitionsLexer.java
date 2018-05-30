// $ANTLR 3.2 Sep 23, 2009 12:02:23 src/org/openmodelica/corba/parser/OMCorbaDefinitions.g 2018-05-29 14:28:16
package org.openmodelica.corba.parser;

import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

public class OMCorbaDefinitionsLexer extends Lexer {
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

    public OMCorbaDefinitionsLexer() {;}
    public OMCorbaDefinitionsLexer(CharStream input) {
        this(input, new RecognizerSharedState());
    }
    public OMCorbaDefinitionsLexer(CharStream input, RecognizerSharedState state) {
        super(input,state);

    }
    public String getGrammarFileName() { return "src/org/openmodelica/corba/parser/OMCorbaDefinitions.g"; }

    // $ANTLR start "T__8"
    public final void mT__8() throws RecognitionException {
        try {
            int _type = T__8;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:9:6: ( '(' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:9:8: '('
            {
            match('(');

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__8"

    // $ANTLR start "T__9"
    public final void mT__9() throws RecognitionException {
        try {
            int _type = T__9;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:10:6: ( ')' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:10:8: ')'
            {
            match(')');

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__9"

    // $ANTLR start "T__10"
    public final void mT__10() throws RecognitionException {
        try {
            int _type = T__10;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:11:7: ( 'package' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:11:9: 'package'
            {
            match("package");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__10"

    // $ANTLR start "T__11"
    public final void mT__11() throws RecognitionException {
        try {
            int _type = T__11;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:12:7: ( 'record' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:12:9: 'record'
            {
            match("record");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__11"

    // $ANTLR start "T__12"
    public final void mT__12() throws RecognitionException {
        try {
            int _type = T__12;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:13:7: ( 'metarecord' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:13:9: 'metarecord'
            {
            match("metarecord");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__12"

    // $ANTLR start "T__13"
    public final void mT__13() throws RecognitionException {
        try {
            int _type = T__13;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:14:7: ( 'extends' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:14:9: 'extends'
            {
            match("extends");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__13"

    // $ANTLR start "T__14"
    public final void mT__14() throws RecognitionException {
        try {
            int _type = T__14;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:15:7: ( 'function' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:15:9: 'function'
            {
            match("function");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__14"

    // $ANTLR start "T__15"
    public final void mT__15() throws RecognitionException {
        try {
            int _type = T__15;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:16:7: ( 'uniontype' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:16:9: 'uniontype'
            {
            match("uniontype");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__15"

    // $ANTLR start "T__16"
    public final void mT__16() throws RecognitionException {
        try {
            int _type = T__16;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:17:7: ( 'partial' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:17:9: 'partial'
            {
            match("partial");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__16"

    // $ANTLR start "T__17"
    public final void mT__17() throws RecognitionException {
        try {
            int _type = T__17;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:18:7: ( 'type' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:18:9: 'type'
            {
            match("type");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__17"

    // $ANTLR start "T__18"
    public final void mT__18() throws RecognitionException {
        try {
            int _type = T__18;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:19:7: ( 'replaceable' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:19:9: 'replaceable'
            {
            match("replaceable");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__18"

    // $ANTLR start "T__19"
    public final void mT__19() throws RecognitionException {
        try {
            int _type = T__19;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:20:7: ( '[' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:20:9: '['
            {
            match('[');

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__19"

    // $ANTLR start "T__20"
    public final void mT__20() throws RecognitionException {
        try {
            int _type = T__20;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:21:7: ( 'input' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:21:9: 'input'
            {
            match("input");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__20"

    // $ANTLR start "T__21"
    public final void mT__21() throws RecognitionException {
        try {
            int _type = T__21;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:22:7: ( 'output' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:22:9: 'output'
            {
            match("output");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__21"

    // $ANTLR start "T__22"
    public final void mT__22() throws RecognitionException {
        try {
            int _type = T__22;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:23:7: ( 'Integer' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:23:9: 'Integer'
            {
            match("Integer");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__22"

    // $ANTLR start "T__23"
    public final void mT__23() throws RecognitionException {
        try {
            int _type = T__23;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:24:7: ( 'Real' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:24:9: 'Real'
            {
            match("Real");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__23"

    // $ANTLR start "T__24"
    public final void mT__24() throws RecognitionException {
        try {
            int _type = T__24;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:25:7: ( 'Boolean' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:25:9: 'Boolean'
            {
            match("Boolean");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__24"

    // $ANTLR start "T__25"
    public final void mT__25() throws RecognitionException {
        try {
            int _type = T__25;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:26:7: ( 'String' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:26:9: 'String'
            {
            match("String");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__25"

    // $ANTLR start "T__26"
    public final void mT__26() throws RecognitionException {
        try {
            int _type = T__26;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:27:7: ( 'list' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:27:9: 'list'
            {
            match("list");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__26"

    // $ANTLR start "T__27"
    public final void mT__27() throws RecognitionException {
        try {
            int _type = T__27;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:28:7: ( '<' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:28:9: '<'
            {
            match('<');

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__27"

    // $ANTLR start "T__28"
    public final void mT__28() throws RecognitionException {
        try {
            int _type = T__28;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:29:7: ( '>' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:29:9: '>'
            {
            match('>');

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__28"

    // $ANTLR start "T__29"
    public final void mT__29() throws RecognitionException {
        try {
            int _type = T__29;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:30:7: ( 'tuple' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:30:9: 'tuple'
            {
            match("tuple");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__29"

    // $ANTLR start "T__30"
    public final void mT__30() throws RecognitionException {
        try {
            int _type = T__30;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:31:7: ( ',' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:31:9: ','
            {
            match(',');

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__30"

    // $ANTLR start "T__31"
    public final void mT__31() throws RecognitionException {
        try {
            int _type = T__31;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:32:7: ( 'Option' )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:32:9: 'Option'
            {
            match("Option");


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "T__31"

    // $ANTLR start "QID"
    public final void mQID() throws RecognitionException {
        try {
            int _type = QID;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:75:5: ( ( ID '.' )+ ID )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:75:7: ( ID '.' )+ ID
            {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:75:7: ( ID '.' )+
            int cnt1=0;
            loop1:
            do {
                int alt1=2;
                alt1 = dfa1.predict(input);
                switch (alt1) {
            	case 1 :
            	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:75:8: ID '.'
            	    {
            	    mID();
            	    match('.');

            	    }
            	    break;

            	default :
            	    if ( cnt1 >= 1 ) break loop1;
                        EarlyExitException eee =
                            new EarlyExitException(1, input);
                        throw eee;
                }
                cnt1++;
            } while (true);

            mID();

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "QID"

    // $ANTLR start "ID"
    public final void mID() throws RecognitionException {
        try {
            int _type = ID;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:76:4: ( ( '_' | 'a' .. 'z' | 'A' .. 'Z' ) ( '_' | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' )* | '\\'' (~ ( '\\\\' | '\\'' ) | '\\\\\\'' | '\\\\\"' | '\\\\?' | '\\\\\\\\' | '\\\\a' | '\\\\b' | '\\\\f' | '\\\\n' | '\\\\r' | '\\\\t' | '\\\\v' )* '\\'' )
            int alt4=2;
            int LA4_0 = input.LA(1);

            if ( ((LA4_0>='A' && LA4_0<='Z')||LA4_0=='_'||(LA4_0>='a' && LA4_0<='z')) ) {
                alt4=1;
            }
            else if ( (LA4_0=='\'') ) {
                alt4=2;
            }
            else {
                NoViableAltException nvae =
                    new NoViableAltException("", 4, 0, input);

                throw nvae;
            }
            switch (alt4) {
                case 1 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:76:6: ( '_' | 'a' .. 'z' | 'A' .. 'Z' ) ( '_' | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' )*
                    {
                    if ( (input.LA(1)>='A' && input.LA(1)<='Z')||input.LA(1)=='_'||(input.LA(1)>='a' && input.LA(1)<='z') ) {
                        input.consume();

                    }
                    else {
                        MismatchedSetException mse = new MismatchedSetException(null,input);
                        recover(mse);
                        throw mse;}

                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:76:29: ( '_' | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' )*
                    loop2:
                    do {
                        int alt2=2;
                        int LA2_0 = input.LA(1);

                        if ( ((LA2_0>='0' && LA2_0<='9')||(LA2_0>='A' && LA2_0<='Z')||LA2_0=='_'||(LA2_0>='a' && LA2_0<='z')) ) {
                            alt2=1;
                        }


                        switch (alt2) {
                    	case 1 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:
                    	    {
                    	    if ( (input.LA(1)>='0' && input.LA(1)<='9')||(input.LA(1)>='A' && input.LA(1)<='Z')||input.LA(1)=='_'||(input.LA(1)>='a' && input.LA(1)<='z') ) {
                    	        input.consume();

                    	    }
                    	    else {
                    	        MismatchedSetException mse = new MismatchedSetException(null,input);
                    	        recover(mse);
                    	        throw mse;}


                    	    }
                    	    break;

                    	default :
                    	    break loop2;
                        }
                    } while (true);


                    }
                    break;
                case 2 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:77:6: '\\'' (~ ( '\\\\' | '\\'' ) | '\\\\\\'' | '\\\\\"' | '\\\\?' | '\\\\\\\\' | '\\\\a' | '\\\\b' | '\\\\f' | '\\\\n' | '\\\\r' | '\\\\t' | '\\\\v' )* '\\''
                    {
                    match('\'');
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:77:10: (~ ( '\\\\' | '\\'' ) | '\\\\\\'' | '\\\\\"' | '\\\\?' | '\\\\\\\\' | '\\\\a' | '\\\\b' | '\\\\f' | '\\\\n' | '\\\\r' | '\\\\t' | '\\\\v' )*
                    loop3:
                    do {
                        int alt3=13;
                        alt3 = dfa3.predict(input);
                        switch (alt3) {
                    	case 1 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:77:11: ~ ( '\\\\' | '\\'' )
                    	    {
                    	    if ( (input.LA(1)>='\u0000' && input.LA(1)<='&')||(input.LA(1)>='(' && input.LA(1)<='[')||(input.LA(1)>=']' && input.LA(1)<='\uFFFF') ) {
                    	        input.consume();

                    	    }
                    	    else {
                    	        MismatchedSetException mse = new MismatchedSetException(null,input);
                    	        recover(mse);
                    	        throw mse;}


                    	    }
                    	    break;
                    	case 2 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:77:24: '\\\\\\''
                    	    {
                    	    match("\\'");


                    	    }
                    	    break;
                    	case 3 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:77:34: '\\\\\"'
                    	    {
                    	    match("\\\"");


                    	    }
                    	    break;
                    	case 4 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:77:41: '\\\\?'
                    	    {
                    	    match("\\?");


                    	    }
                    	    break;
                    	case 5 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:77:49: '\\\\\\\\'
                    	    {
                    	    match("\\\\");


                    	    }
                    	    break;
                    	case 6 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:77:58: '\\\\a'
                    	    {
                    	    match("\\a");


                    	    }
                    	    break;
                    	case 7 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:77:66: '\\\\b'
                    	    {
                    	    match("\\b");


                    	    }
                    	    break;
                    	case 8 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:77:74: '\\\\f'
                    	    {
                    	    match("\\f");


                    	    }
                    	    break;
                    	case 9 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:77:82: '\\\\n'
                    	    {
                    	    match("\\n");


                    	    }
                    	    break;
                    	case 10 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:77:90: '\\\\r'
                    	    {
                    	    match("\\r");


                    	    }
                    	    break;
                    	case 11 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:77:98: '\\\\t'
                    	    {
                    	    match("\\t");


                    	    }
                    	    break;
                    	case 12 :
                    	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:77:106: '\\\\v'
                    	    {
                    	    match("\\v");


                    	    }
                    	    break;

                    	default :
                    	    break loop3;
                        }
                    } while (true);

                    match('\'');

                    }
                    break;

            }
            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "ID"

    // $ANTLR start "INT"
    public final void mINT() throws RecognitionException {
        try {
            int _type = INT;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:78:5: ( ( '-' )? ( '0' .. '9' )+ )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:78:8: ( '-' )? ( '0' .. '9' )+
            {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:78:8: ( '-' )?
            int alt5=2;
            int LA5_0 = input.LA(1);

            if ( (LA5_0=='-') ) {
                alt5=1;
            }
            switch (alt5) {
                case 1 :
                    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:78:8: '-'
                    {
                    match('-');

                    }
                    break;

            }

            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:78:12: ( '0' .. '9' )+
            int cnt6=0;
            loop6:
            do {
                int alt6=2;
                int LA6_0 = input.LA(1);

                if ( ((LA6_0>='0' && LA6_0<='9')) ) {
                    alt6=1;
                }


                switch (alt6) {
            	case 1 :
            	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:78:12: '0' .. '9'
            	    {
            	    matchRange('0','9');

            	    }
            	    break;

            	default :
            	    if ( cnt6 >= 1 ) break loop6;
                        EarlyExitException eee =
                            new EarlyExitException(6, input);
                        throw eee;
                }
                cnt6++;
            } while (true);


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "INT"

    // $ANTLR start "WS"
    public final void mWS() throws RecognitionException {
        try {
            int _type = WS;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:79:5: ( ( '\\r' | '\\n' | ' ' | '\\t' )+ )
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:79:9: ( '\\r' | '\\n' | ' ' | '\\t' )+
            {
            // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:79:9: ( '\\r' | '\\n' | ' ' | '\\t' )+
            int cnt7=0;
            loop7:
            do {
                int alt7=2;
                int LA7_0 = input.LA(1);

                if ( ((LA7_0>='\t' && LA7_0<='\n')||LA7_0=='\r'||LA7_0==' ') ) {
                    alt7=1;
                }


                switch (alt7) {
            	case 1 :
            	    // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:
            	    {
            	    if ( (input.LA(1)>='\t' && input.LA(1)<='\n')||input.LA(1)=='\r'||input.LA(1)==' ' ) {
            	        input.consume();

            	    }
            	    else {
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;}


            	    }
            	    break;

            	default :
            	    if ( cnt7 >= 1 ) break loop7;
                        EarlyExitException eee =
                            new EarlyExitException(7, input);
                        throw eee;
                }
                cnt7++;
            } while (true);

            skip();

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "WS"

    public void mTokens() throws RecognitionException {
        // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:8: ( T__8 | T__9 | T__10 | T__11 | T__12 | T__13 | T__14 | T__15 | T__16 | T__17 | T__18 | T__19 | T__20 | T__21 | T__22 | T__23 | T__24 | T__25 | T__26 | T__27 | T__28 | T__29 | T__30 | T__31 | QID | ID | INT | WS )
        int alt8=28;
        alt8 = dfa8.predict(input);
        switch (alt8) {
            case 1 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:10: T__8
                {
                mT__8();

                }
                break;
            case 2 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:15: T__9
                {
                mT__9();

                }
                break;
            case 3 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:20: T__10
                {
                mT__10();

                }
                break;
            case 4 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:26: T__11
                {
                mT__11();

                }
                break;
            case 5 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:32: T__12
                {
                mT__12();

                }
                break;
            case 6 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:38: T__13
                {
                mT__13();

                }
                break;
            case 7 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:44: T__14
                {
                mT__14();

                }
                break;
            case 8 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:50: T__15
                {
                mT__15();

                }
                break;
            case 9 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:56: T__16
                {
                mT__16();

                }
                break;
            case 10 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:62: T__17
                {
                mT__17();

                }
                break;
            case 11 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:68: T__18
                {
                mT__18();

                }
                break;
            case 12 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:74: T__19
                {
                mT__19();

                }
                break;
            case 13 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:80: T__20
                {
                mT__20();

                }
                break;
            case 14 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:86: T__21
                {
                mT__21();

                }
                break;
            case 15 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:92: T__22
                {
                mT__22();

                }
                break;
            case 16 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:98: T__23
                {
                mT__23();

                }
                break;
            case 17 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:104: T__24
                {
                mT__24();

                }
                break;
            case 18 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:110: T__25
                {
                mT__25();

                }
                break;
            case 19 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:116: T__26
                {
                mT__26();

                }
                break;
            case 20 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:122: T__27
                {
                mT__27();

                }
                break;
            case 21 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:128: T__28
                {
                mT__28();

                }
                break;
            case 22 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:134: T__29
                {
                mT__29();

                }
                break;
            case 23 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:140: T__30
                {
                mT__30();

                }
                break;
            case 24 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:146: T__31
                {
                mT__31();

                }
                break;
            case 25 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:152: QID
                {
                mQID();

                }
                break;
            case 26 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:156: ID
                {
                mID();

                }
                break;
            case 27 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:159: INT
                {
                mINT();

                }
                break;
            case 28 :
                // src/org/openmodelica/corba/parser/OMCorbaDefinitions.g:1:163: WS
                {
                mWS();

                }
                break;

        }

    }


    protected DFA1 dfa1 = new DFA1(this);
    protected DFA3 dfa3 = new DFA3(this);
    protected DFA8 dfa8 = new DFA8(this);
    static final String DFA1_eotS =
        "\1\uffff\1\4\1\uffff\1\4\4\uffff\1\4\13\uffff";
    static final String DFA1_eofS =
        "\24\uffff";
    static final String DFA1_minS =
        "\1\47\1\56\1\0\1\56\2\uffff\1\0\1\42\1\56\13\0";
    static final String DFA1_maxS =
        "\2\172\1\uffff\1\172\2\uffff\1\uffff\1\166\1\56\13\uffff";
    static final String DFA1_acceptS =
        "\4\uffff\1\2\1\1\16\uffff";
    static final String DFA1_specialS =
        "\2\uffff\1\2\3\uffff\1\10\2\uffff\1\13\1\0\1\3\1\5\1\7\1\12\1\14"+
        "\1\1\1\4\1\6\1\11}>";
    static final String[] DFA1_transitionS = {
            "\1\2\31\uffff\32\1\4\uffff\1\1\1\uffff\32\1",
            "\1\5\1\uffff\12\3\7\uffff\32\3\4\uffff\1\3\1\uffff\32\3",
            "\47\6\1\10\64\6\1\7\uffa3\6",
            "\1\5\1\uffff\12\3\7\uffff\32\3\4\uffff\1\3\1\uffff\32\3",
            "",
            "",
            "\47\6\1\10\64\6\1\7\uffa3\6",
            "\1\12\4\uffff\1\11\27\uffff\1\13\34\uffff\1\14\4\uffff\1\15"+
            "\1\16\3\uffff\1\17\7\uffff\1\20\3\uffff\1\21\1\uffff\1\22\1"+
            "\uffff\1\23",
            "\1\5",
            "\47\6\1\10\64\6\1\7\uffa3\6",
            "\47\6\1\10\64\6\1\7\uffa3\6",
            "\47\6\1\10\64\6\1\7\uffa3\6",
            "\47\6\1\10\64\6\1\7\uffa3\6",
            "\47\6\1\10\64\6\1\7\uffa3\6",
            "\47\6\1\10\64\6\1\7\uffa3\6",
            "\47\6\1\10\64\6\1\7\uffa3\6",
            "\47\6\1\10\64\6\1\7\uffa3\6",
            "\47\6\1\10\64\6\1\7\uffa3\6",
            "\47\6\1\10\64\6\1\7\uffa3\6",
            "\47\6\1\10\64\6\1\7\uffa3\6"
    };

    static final short[] DFA1_eot = DFA.unpackEncodedString(DFA1_eotS);
    static final short[] DFA1_eof = DFA.unpackEncodedString(DFA1_eofS);
    static final char[] DFA1_min = DFA.unpackEncodedStringToUnsignedChars(DFA1_minS);
    static final char[] DFA1_max = DFA.unpackEncodedStringToUnsignedChars(DFA1_maxS);
    static final short[] DFA1_accept = DFA.unpackEncodedString(DFA1_acceptS);
    static final short[] DFA1_special = DFA.unpackEncodedString(DFA1_specialS);
    static final short[][] DFA1_transition;

    static {
        int numStates = DFA1_transitionS.length;
        DFA1_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA1_transition[i] = DFA.unpackEncodedString(DFA1_transitionS[i]);
        }
    }

    class DFA1 extends DFA {

        public DFA1(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 1;
            this.eot = DFA1_eot;
            this.eof = DFA1_eof;
            this.min = DFA1_min;
            this.max = DFA1_max;
            this.accept = DFA1_accept;
            this.special = DFA1_special;
            this.transition = DFA1_transition;
        }
        public String getDescription() {
            return "()+ loopback of 75:7: ( ID '.' )+";
        }
        public int specialStateTransition(int s, IntStream _input) throws NoViableAltException {
            IntStream input = _input;
        	int _s = s;
            switch ( s ) {
                    case 0 :
                        int LA1_10 = input.LA(1);

                        s = -1;
                        if ( (LA1_10=='\'') ) {s = 8;}

                        else if ( ((LA1_10>='\u0000' && LA1_10<='&')||(LA1_10>='(' && LA1_10<='[')||(LA1_10>=']' && LA1_10<='\uFFFF')) ) {s = 6;}

                        else if ( (LA1_10=='\\') ) {s = 7;}

                        if ( s>=0 ) return s;
                        break;
                    case 1 :
                        int LA1_16 = input.LA(1);

                        s = -1;
                        if ( (LA1_16=='\'') ) {s = 8;}

                        else if ( ((LA1_16>='\u0000' && LA1_16<='&')||(LA1_16>='(' && LA1_16<='[')||(LA1_16>=']' && LA1_16<='\uFFFF')) ) {s = 6;}

                        else if ( (LA1_16=='\\') ) {s = 7;}

                        if ( s>=0 ) return s;
                        break;
                    case 2 :
                        int LA1_2 = input.LA(1);

                        s = -1;
                        if ( ((LA1_2>='\u0000' && LA1_2<='&')||(LA1_2>='(' && LA1_2<='[')||(LA1_2>=']' && LA1_2<='\uFFFF')) ) {s = 6;}

                        else if ( (LA1_2=='\\') ) {s = 7;}

                        else if ( (LA1_2=='\'') ) {s = 8;}

                        if ( s>=0 ) return s;
                        break;
                    case 3 :
                        int LA1_11 = input.LA(1);

                        s = -1;
                        if ( (LA1_11=='\'') ) {s = 8;}

                        else if ( ((LA1_11>='\u0000' && LA1_11<='&')||(LA1_11>='(' && LA1_11<='[')||(LA1_11>=']' && LA1_11<='\uFFFF')) ) {s = 6;}

                        else if ( (LA1_11=='\\') ) {s = 7;}

                        if ( s>=0 ) return s;
                        break;
                    case 4 :
                        int LA1_17 = input.LA(1);

                        s = -1;
                        if ( (LA1_17=='\'') ) {s = 8;}

                        else if ( ((LA1_17>='\u0000' && LA1_17<='&')||(LA1_17>='(' && LA1_17<='[')||(LA1_17>=']' && LA1_17<='\uFFFF')) ) {s = 6;}

                        else if ( (LA1_17=='\\') ) {s = 7;}

                        if ( s>=0 ) return s;
                        break;
                    case 5 :
                        int LA1_12 = input.LA(1);

                        s = -1;
                        if ( (LA1_12=='\'') ) {s = 8;}

                        else if ( ((LA1_12>='\u0000' && LA1_12<='&')||(LA1_12>='(' && LA1_12<='[')||(LA1_12>=']' && LA1_12<='\uFFFF')) ) {s = 6;}

                        else if ( (LA1_12=='\\') ) {s = 7;}

                        if ( s>=0 ) return s;
                        break;
                    case 6 :
                        int LA1_18 = input.LA(1);

                        s = -1;
                        if ( (LA1_18=='\'') ) {s = 8;}

                        else if ( ((LA1_18>='\u0000' && LA1_18<='&')||(LA1_18>='(' && LA1_18<='[')||(LA1_18>=']' && LA1_18<='\uFFFF')) ) {s = 6;}

                        else if ( (LA1_18=='\\') ) {s = 7;}

                        if ( s>=0 ) return s;
                        break;
                    case 7 :
                        int LA1_13 = input.LA(1);

                        s = -1;
                        if ( (LA1_13=='\'') ) {s = 8;}

                        else if ( ((LA1_13>='\u0000' && LA1_13<='&')||(LA1_13>='(' && LA1_13<='[')||(LA1_13>=']' && LA1_13<='\uFFFF')) ) {s = 6;}

                        else if ( (LA1_13=='\\') ) {s = 7;}

                        if ( s>=0 ) return s;
                        break;
                    case 8 :
                        int LA1_6 = input.LA(1);

                        s = -1;
                        if ( (LA1_6=='\'') ) {s = 8;}

                        else if ( ((LA1_6>='\u0000' && LA1_6<='&')||(LA1_6>='(' && LA1_6<='[')||(LA1_6>=']' && LA1_6<='\uFFFF')) ) {s = 6;}

                        else if ( (LA1_6=='\\') ) {s = 7;}

                        if ( s>=0 ) return s;
                        break;
                    case 9 :
                        int LA1_19 = input.LA(1);

                        s = -1;
                        if ( (LA1_19=='\'') ) {s = 8;}

                        else if ( ((LA1_19>='\u0000' && LA1_19<='&')||(LA1_19>='(' && LA1_19<='[')||(LA1_19>=']' && LA1_19<='\uFFFF')) ) {s = 6;}

                        else if ( (LA1_19=='\\') ) {s = 7;}

                        if ( s>=0 ) return s;
                        break;
                    case 10 :
                        int LA1_14 = input.LA(1);

                        s = -1;
                        if ( (LA1_14=='\'') ) {s = 8;}

                        else if ( ((LA1_14>='\u0000' && LA1_14<='&')||(LA1_14>='(' && LA1_14<='[')||(LA1_14>=']' && LA1_14<='\uFFFF')) ) {s = 6;}

                        else if ( (LA1_14=='\\') ) {s = 7;}

                        if ( s>=0 ) return s;
                        break;
                    case 11 :
                        int LA1_9 = input.LA(1);

                        s = -1;
                        if ( (LA1_9=='\'') ) {s = 8;}

                        else if ( ((LA1_9>='\u0000' && LA1_9<='&')||(LA1_9>='(' && LA1_9<='[')||(LA1_9>=']' && LA1_9<='\uFFFF')) ) {s = 6;}

                        else if ( (LA1_9=='\\') ) {s = 7;}

                        if ( s>=0 ) return s;
                        break;
                    case 12 :
                        int LA1_15 = input.LA(1);

                        s = -1;
                        if ( (LA1_15=='\'') ) {s = 8;}

                        else if ( ((LA1_15>='\u0000' && LA1_15<='&')||(LA1_15>='(' && LA1_15<='[')||(LA1_15>=']' && LA1_15<='\uFFFF')) ) {s = 6;}

                        else if ( (LA1_15=='\\') ) {s = 7;}

                        if ( s>=0 ) return s;
                        break;
            }
            NoViableAltException nvae =
                new NoViableAltException(getDescription(), 1, _s, input);
            error(nvae);
            throw nvae;
        }
    }
    static final String DFA3_eotS =
        "\17\uffff";
    static final String DFA3_eofS =
        "\17\uffff";
    static final String DFA3_minS =
        "\1\0\2\uffff\1\42\13\uffff";
    static final String DFA3_maxS =
        "\1\uffff\2\uffff\1\166\13\uffff";
    static final String DFA3_acceptS =
        "\1\uffff\1\15\1\1\1\uffff\1\2\1\3\1\4\1\5\1\6\1\7\1\10\1\11\1\12"+
        "\1\13\1\14";
    static final String DFA3_specialS =
        "\1\0\16\uffff}>";
    static final String[] DFA3_transitionS = {
            "\47\2\1\1\64\2\1\3\uffa3\2",
            "",
            "",
            "\1\5\4\uffff\1\4\27\uffff\1\6\34\uffff\1\7\4\uffff\1\10\1\11"+
            "\3\uffff\1\12\7\uffff\1\13\3\uffff\1\14\1\uffff\1\15\1\uffff"+
            "\1\16",
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

    static final short[] DFA3_eot = DFA.unpackEncodedString(DFA3_eotS);
    static final short[] DFA3_eof = DFA.unpackEncodedString(DFA3_eofS);
    static final char[] DFA3_min = DFA.unpackEncodedStringToUnsignedChars(DFA3_minS);
    static final char[] DFA3_max = DFA.unpackEncodedStringToUnsignedChars(DFA3_maxS);
    static final short[] DFA3_accept = DFA.unpackEncodedString(DFA3_acceptS);
    static final short[] DFA3_special = DFA.unpackEncodedString(DFA3_specialS);
    static final short[][] DFA3_transition;

    static {
        int numStates = DFA3_transitionS.length;
        DFA3_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA3_transition[i] = DFA.unpackEncodedString(DFA3_transitionS[i]);
        }
    }

    class DFA3 extends DFA {

        public DFA3(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 3;
            this.eot = DFA3_eot;
            this.eof = DFA3_eof;
            this.min = DFA3_min;
            this.max = DFA3_max;
            this.accept = DFA3_accept;
            this.special = DFA3_special;
            this.transition = DFA3_transition;
        }
        public String getDescription() {
            return "()* loopback of 77:10: (~ ( '\\\\' | '\\'' ) | '\\\\\\'' | '\\\\\"' | '\\\\?' | '\\\\\\\\' | '\\\\a' | '\\\\b' | '\\\\f' | '\\\\n' | '\\\\r' | '\\\\t' | '\\\\v' )*";
        }
        public int specialStateTransition(int s, IntStream _input) throws NoViableAltException {
            IntStream input = _input;
        	int _s = s;
            switch ( s ) {
                    case 0 :
                        int LA3_0 = input.LA(1);

                        s = -1;
                        if ( (LA3_0=='\'') ) {s = 1;}

                        else if ( ((LA3_0>='\u0000' && LA3_0<='&')||(LA3_0>='(' && LA3_0<='[')||(LA3_0>=']' && LA3_0<='\uFFFF')) ) {s = 2;}

                        else if ( (LA3_0=='\\') ) {s = 3;}

                        if ( s>=0 ) return s;
                        break;
            }
            NoViableAltException nvae =
                new NoViableAltException(getDescription(), 3, _s, input);
            error(nvae);
            throw nvae;
        }
    }
    static final String DFA8_eotS =
        "\3\uffff\7\34\1\uffff\7\34\3\uffff\2\34\3\uffff\2\34\2\uffff\17"+
        "\34\2\uffff\23\34\13\uffff\10\34\1\147\4\34\1\154\2\34\1\157\11"+
        "\34\1\uffff\1\171\1\172\2\34\1\uffff\2\34\1\uffff\3\34\1\u0082\5"+
        "\34\2\uffff\1\u0088\2\34\1\u008b\1\u008c\1\u008d\1\u008e\1\uffff"+
        "\2\34\1\u0091\2\34\1\uffff\1\u0094\1\u0095\4\uffff\2\34\1\uffff"+
        "\1\u0098\1\34\2\uffff\2\34\1\uffff\1\u009c\1\34\1\u009e\1\uffff"+
        "\1\u009f\2\uffff";
    static final String DFA8_eofS =
        "\u00a0\uffff";
    static final String DFA8_minS =
        "\1\11\2\uffff\7\56\1\uffff\7\56\3\uffff\2\56\1\0\2\uffff\2\56\2"+
        "\uffff\17\56\1\0\1\42\23\56\13\0\32\56\1\uffff\4\56\1\uffff\2\56"+
        "\1\uffff\11\56\2\uffff\7\56\1\uffff\5\56\1\uffff\2\56\4\uffff\2"+
        "\56\1\uffff\2\56\2\uffff\2\56\1\uffff\3\56\1\uffff\1\56\2\uffff";
    static final String DFA8_maxS =
        "\1\172\2\uffff\7\172\1\uffff\7\172\3\uffff\2\172\1\uffff\2\uffff"+
        "\2\172\2\uffff\17\172\1\uffff\1\166\1\56\22\172\13\uffff\32\172"+
        "\1\uffff\4\172\1\uffff\2\172\1\uffff\11\172\2\uffff\7\172\1\uffff"+
        "\5\172\1\uffff\2\172\4\uffff\2\172\1\uffff\2\172\2\uffff\2\172\1"+
        "\uffff\3\172\1\uffff\1\172\2\uffff";
    static final String DFA8_acceptS =
        "\1\uffff\1\1\1\2\7\uffff\1\14\7\uffff\1\24\1\25\1\27\3\uffff\1\33"+
        "\1\34\2\uffff\1\32\1\31\111\uffff\1\12\4\uffff\1\20\2\uffff\1\23"+
        "\11\uffff\1\26\1\15\7\uffff\1\4\5\uffff\1\16\2\uffff\1\22\1\30\1"+
        "\3\1\11\2\uffff\1\6\2\uffff\1\17\1\21\2\uffff\1\7\3\uffff\1\10\1"+
        "\uffff\1\5\1\13";
    static final String DFA8_specialS =
        "\27\uffff\1\2\25\uffff\1\3\24\uffff\1\4\1\5\1\6\1\7\1\10\1\11\1"+
        "\12\1\13\1\14\1\0\1\1\123\uffff}>";
    static final String[] DFA8_transitionS = {
            "\2\31\2\uffff\1\31\22\uffff\1\31\6\uffff\1\27\1\1\1\2\2\uffff"+
            "\1\24\1\30\2\uffff\12\30\2\uffff\1\22\1\uffff\1\23\2\uffff\1"+
            "\26\1\17\6\26\1\15\5\26\1\25\2\26\1\16\1\20\7\26\1\12\3\uffff"+
            "\1\26\1\uffff\4\26\1\6\1\7\2\26\1\13\2\26\1\21\1\5\1\26\1\14"+
            "\1\3\1\26\1\4\1\26\1\11\1\10\5\26",
            "",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\1\32"+
            "\31\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\4\33"+
            "\1\36\25\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\4\33"+
            "\1\37\25\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\27\33"+
            "\1\40\2\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\24\33"+
            "\1\41\5\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\15\33"+
            "\1\42\14\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\24\33"+
            "\1\44\3\33\1\43\1\33",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\15\33"+
            "\1\45\14\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\24\33"+
            "\1\46\5\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\15\33"+
            "\1\47\14\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\4\33"+
            "\1\50\25\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\16\33"+
            "\1\51\13\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\23\33"+
            "\1\52\6\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\10\33"+
            "\1\53\21\33",
            "",
            "",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\17\33"+
            "\1\54\12\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\47\55\1\57\64\55\1\56\uffa3\55",
            "",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\2\33"+
            "\1\60\16\33\1\61\10\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\2\33"+
            "\1\62\14\33\1\63\12\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\23\33"+
            "\1\64\6\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\23\33"+
            "\1\65\6\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\15\33"+
            "\1\66\14\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\10\33"+
            "\1\67\21\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\17\33"+
            "\1\70\12\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\17\33"+
            "\1\71\12\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\17\33"+
            "\1\72\12\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\23\33"+
            "\1\73\6\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\23\33"+
            "\1\74\6\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\1\75"+
            "\31\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\16\33"+
            "\1\76\13\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\21\33"+
            "\1\77\10\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\22\33"+
            "\1\100\7\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\23\33"+
            "\1\101\6\33",
            "\47\55\1\57\64\55\1\56\uffa3\55",
            "\1\103\4\uffff\1\102\27\uffff\1\104\34\uffff\1\105\4\uffff"+
            "\1\106\1\107\3\uffff\1\110\7\uffff\1\111\3\uffff\1\112\1\uffff"+
            "\1\113\1\uffff\1\114",
            "\1\35",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\12\33"+
            "\1\115\17\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\23\33"+
            "\1\116\6\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\16\33"+
            "\1\117\13\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\13\33"+
            "\1\120\16\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\1\121"+
            "\31\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\4\33"+
            "\1\122\25\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\2\33"+
            "\1\123\27\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\16\33"+
            "\1\124\13\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\4\33"+
            "\1\125\25\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\13\33"+
            "\1\126\16\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\24\33"+
            "\1\127\5\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\17\33"+
            "\1\130\12\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\4\33"+
            "\1\131\25\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\13\33"+
            "\1\132\16\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\13\33"+
            "\1\133\16\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\10\33"+
            "\1\134\21\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\23\33"+
            "\1\135\6\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\10\33"+
            "\1\136\21\33",
            "\47\55\1\57\64\55\1\56\uffa3\55",
            "\47\55\1\57\64\55\1\56\uffa3\55",
            "\47\55\1\57\64\55\1\56\uffa3\55",
            "\47\55\1\57\64\55\1\56\uffa3\55",
            "\47\55\1\57\64\55\1\56\uffa3\55",
            "\47\55\1\57\64\55\1\56\uffa3\55",
            "\47\55\1\57\64\55\1\56\uffa3\55",
            "\47\55\1\57\64\55\1\56\uffa3\55",
            "\47\55\1\57\64\55\1\56\uffa3\55",
            "\47\55\1\57\64\55\1\56\uffa3\55",
            "\47\55\1\57\64\55\1\56\uffa3\55",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\1\137"+
            "\31\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\10\33"+
            "\1\140\21\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\21\33"+
            "\1\141\10\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\1\142"+
            "\31\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\21\33"+
            "\1\143\10\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\15\33"+
            "\1\144\14\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\23\33"+
            "\1\145\6\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\15\33"+
            "\1\146\14\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\4\33"+
            "\1\150\25\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\23\33"+
            "\1\151\6\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\24\33"+
            "\1\152\5\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\6\33"+
            "\1\153\23\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\4\33"+
            "\1\155\25\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\15\33"+
            "\1\156\14\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\16\33"+
            "\1\160\13\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\6\33"+
            "\1\161\23\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\1\162"+
            "\31\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\3\33"+
            "\1\163\26\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\2\33"+
            "\1\164\27\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\4\33"+
            "\1\165\25\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\3\33"+
            "\1\166\26\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\10\33"+
            "\1\167\21\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\23\33"+
            "\1\170\6\33",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\23\33"+
            "\1\173\6\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\4\33"+
            "\1\174\25\33",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\1\175"+
            "\31\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\6\33"+
            "\1\176\23\33",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\15\33"+
            "\1\177\14\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\4\33"+
            "\1\u0080\25\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\13\33"+
            "\1\u0081\16\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\4\33"+
            "\1\u0083\25\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\2\33"+
            "\1\u0084\27\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\22\33"+
            "\1\u0085\7\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\16\33"+
            "\1\u0086\13\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\30\33"+
            "\1\u0087\1\33",
            "",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\21\33"+
            "\1\u0089\10\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\15\33"+
            "\1\u008a\14\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\1\u008f"+
            "\31\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\16\33"+
            "\1\u0090\13\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\15\33"+
            "\1\u0092\14\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\17\33"+
            "\1\u0093\12\33",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "",
            "",
            "",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\1\33"+
            "\1\u0096\30\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\21\33"+
            "\1\u0097\10\33",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\4\33"+
            "\1\u0099\25\33",
            "",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\13\33"+
            "\1\u009a\16\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\3\33"+
            "\1\u009b\26\33",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\4\33"+
            "\1\u009d\25\33",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "",
            "\1\35\1\uffff\12\33\7\uffff\32\33\4\uffff\1\33\1\uffff\32\33",
            "",
            ""
    };

    static final short[] DFA8_eot = DFA.unpackEncodedString(DFA8_eotS);
    static final short[] DFA8_eof = DFA.unpackEncodedString(DFA8_eofS);
    static final char[] DFA8_min = DFA.unpackEncodedStringToUnsignedChars(DFA8_minS);
    static final char[] DFA8_max = DFA.unpackEncodedStringToUnsignedChars(DFA8_maxS);
    static final short[] DFA8_accept = DFA.unpackEncodedString(DFA8_acceptS);
    static final short[] DFA8_special = DFA.unpackEncodedString(DFA8_specialS);
    static final short[][] DFA8_transition;

    static {
        int numStates = DFA8_transitionS.length;
        DFA8_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA8_transition[i] = DFA.unpackEncodedString(DFA8_transitionS[i]);
        }
    }

    class DFA8 extends DFA {

        public DFA8(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 8;
            this.eot = DFA8_eot;
            this.eof = DFA8_eof;
            this.min = DFA8_min;
            this.max = DFA8_max;
            this.accept = DFA8_accept;
            this.special = DFA8_special;
            this.transition = DFA8_transition;
        }
        public String getDescription() {
            return "1:1: Tokens : ( T__8 | T__9 | T__10 | T__11 | T__12 | T__13 | T__14 | T__15 | T__16 | T__17 | T__18 | T__19 | T__20 | T__21 | T__22 | T__23 | T__24 | T__25 | T__26 | T__27 | T__28 | T__29 | T__30 | T__31 | QID | ID | INT | WS );";
        }
        public int specialStateTransition(int s, IntStream _input) throws NoViableAltException {
            IntStream input = _input;
        	int _s = s;
            switch ( s ) {
                    case 0 :
                        int LA8_75 = input.LA(1);

                        s = -1;
                        if ( (LA8_75=='\'') ) {s = 47;}

                        else if ( ((LA8_75>='\u0000' && LA8_75<='&')||(LA8_75>='(' && LA8_75<='[')||(LA8_75>=']' && LA8_75<='\uFFFF')) ) {s = 45;}

                        else if ( (LA8_75=='\\') ) {s = 46;}

                        if ( s>=0 ) return s;
                        break;
                    case 1 :
                        int LA8_76 = input.LA(1);

                        s = -1;
                        if ( (LA8_76=='\'') ) {s = 47;}

                        else if ( ((LA8_76>='\u0000' && LA8_76<='&')||(LA8_76>='(' && LA8_76<='[')||(LA8_76>=']' && LA8_76<='\uFFFF')) ) {s = 45;}

                        else if ( (LA8_76=='\\') ) {s = 46;}

                        if ( s>=0 ) return s;
                        break;
                    case 2 :
                        int LA8_23 = input.LA(1);

                        s = -1;
                        if ( ((LA8_23>='\u0000' && LA8_23<='&')||(LA8_23>='(' && LA8_23<='[')||(LA8_23>=']' && LA8_23<='\uFFFF')) ) {s = 45;}

                        else if ( (LA8_23=='\\') ) {s = 46;}

                        else if ( (LA8_23=='\'') ) {s = 47;}

                        if ( s>=0 ) return s;
                        break;
                    case 3 :
                        int LA8_45 = input.LA(1);

                        s = -1;
                        if ( (LA8_45=='\'') ) {s = 47;}

                        else if ( ((LA8_45>='\u0000' && LA8_45<='&')||(LA8_45>='(' && LA8_45<='[')||(LA8_45>=']' && LA8_45<='\uFFFF')) ) {s = 45;}

                        else if ( (LA8_45=='\\') ) {s = 46;}

                        if ( s>=0 ) return s;
                        break;
                    case 4 :
                        int LA8_66 = input.LA(1);

                        s = -1;
                        if ( (LA8_66=='\'') ) {s = 47;}

                        else if ( ((LA8_66>='\u0000' && LA8_66<='&')||(LA8_66>='(' && LA8_66<='[')||(LA8_66>=']' && LA8_66<='\uFFFF')) ) {s = 45;}

                        else if ( (LA8_66=='\\') ) {s = 46;}

                        if ( s>=0 ) return s;
                        break;
                    case 5 :
                        int LA8_67 = input.LA(1);

                        s = -1;
                        if ( (LA8_67=='\'') ) {s = 47;}

                        else if ( ((LA8_67>='\u0000' && LA8_67<='&')||(LA8_67>='(' && LA8_67<='[')||(LA8_67>=']' && LA8_67<='\uFFFF')) ) {s = 45;}

                        else if ( (LA8_67=='\\') ) {s = 46;}

                        if ( s>=0 ) return s;
                        break;
                    case 6 :
                        int LA8_68 = input.LA(1);

                        s = -1;
                        if ( (LA8_68=='\'') ) {s = 47;}

                        else if ( ((LA8_68>='\u0000' && LA8_68<='&')||(LA8_68>='(' && LA8_68<='[')||(LA8_68>=']' && LA8_68<='\uFFFF')) ) {s = 45;}

                        else if ( (LA8_68=='\\') ) {s = 46;}

                        if ( s>=0 ) return s;
                        break;
                    case 7 :
                        int LA8_69 = input.LA(1);

                        s = -1;
                        if ( (LA8_69=='\'') ) {s = 47;}

                        else if ( ((LA8_69>='\u0000' && LA8_69<='&')||(LA8_69>='(' && LA8_69<='[')||(LA8_69>=']' && LA8_69<='\uFFFF')) ) {s = 45;}

                        else if ( (LA8_69=='\\') ) {s = 46;}

                        if ( s>=0 ) return s;
                        break;
                    case 8 :
                        int LA8_70 = input.LA(1);

                        s = -1;
                        if ( (LA8_70=='\'') ) {s = 47;}

                        else if ( ((LA8_70>='\u0000' && LA8_70<='&')||(LA8_70>='(' && LA8_70<='[')||(LA8_70>=']' && LA8_70<='\uFFFF')) ) {s = 45;}

                        else if ( (LA8_70=='\\') ) {s = 46;}

                        if ( s>=0 ) return s;
                        break;
                    case 9 :
                        int LA8_71 = input.LA(1);

                        s = -1;
                        if ( (LA8_71=='\'') ) {s = 47;}

                        else if ( ((LA8_71>='\u0000' && LA8_71<='&')||(LA8_71>='(' && LA8_71<='[')||(LA8_71>=']' && LA8_71<='\uFFFF')) ) {s = 45;}

                        else if ( (LA8_71=='\\') ) {s = 46;}

                        if ( s>=0 ) return s;
                        break;
                    case 10 :
                        int LA8_72 = input.LA(1);

                        s = -1;
                        if ( (LA8_72=='\'') ) {s = 47;}

                        else if ( ((LA8_72>='\u0000' && LA8_72<='&')||(LA8_72>='(' && LA8_72<='[')||(LA8_72>=']' && LA8_72<='\uFFFF')) ) {s = 45;}

                        else if ( (LA8_72=='\\') ) {s = 46;}

                        if ( s>=0 ) return s;
                        break;
                    case 11 :
                        int LA8_73 = input.LA(1);

                        s = -1;
                        if ( (LA8_73=='\'') ) {s = 47;}

                        else if ( ((LA8_73>='\u0000' && LA8_73<='&')||(LA8_73>='(' && LA8_73<='[')||(LA8_73>=']' && LA8_73<='\uFFFF')) ) {s = 45;}

                        else if ( (LA8_73=='\\') ) {s = 46;}

                        if ( s>=0 ) return s;
                        break;
                    case 12 :
                        int LA8_74 = input.LA(1);

                        s = -1;
                        if ( (LA8_74=='\'') ) {s = 47;}

                        else if ( ((LA8_74>='\u0000' && LA8_74<='&')||(LA8_74>='(' && LA8_74<='[')||(LA8_74>=']' && LA8_74<='\uFFFF')) ) {s = 45;}

                        else if ( (LA8_74=='\\') ) {s = 46;}

                        if ( s>=0 ) return s;
                        break;
            }
            NoViableAltException nvae =
                new NoViableAltException(getDescription(), 8, _s, input);
            error(nvae);
            throw nvae;
        }
    }


}