#include "\z\ace\addons\main\script_macros.hpp"

// custom macros go here...
#define GET_NUMBER(config,default) (if (isNumber (config)) then {getNumber (config)} else {default})
#define GET_TEXT(config,default) (if (isText (config)) then {getText (config)} else {default})
#define GET_ARRAY(config,default) (if (isArray (config)) then {getArray (config)} else {default})

// Macros for Fortify Presets
#define MACRO_FORTIFY_ADD(CLASSNAME,COST,LIMIT) class _xx_##CLASSNAME { \
    name = #CLASSNAME; \
    cost = COST; \
    limit = LIMIT; \
}

// updated TRACEs for feedback with systemChat
#ifdef RELEASE_BUILD
	#define CHAT_SYS(LEVEL,MESSAGE) /* disabled */
#else
	#define CHAT_SYS(LEVEL,MESSAGE) systemChat LOG_SYS_FORMAT(LEVEL,MESSAGE)
#endif

#define CHAT_SYS_FILELINENUMBERS(LEVEL,MESSAGE) CHAT_SYS(LEVEL,format [ARR_4('%1 %2:%3',MESSAGE,__FILE__,__LINE__ + 1)])

#ifdef DEBUG_MODE_FULL
	#define TRACE_CHAT_1(MESSAGE,A) TRACE_1((MESSAGE),A); CHAT_SYS_FILELINENUMBERS('TRACE',PFORMAT_1(str diag_frameNo + ' ' + (MESSAGE),A))
	#define TRACE_CHAT_2(MESSAGE,A,B) TRACE_2((MESSAGE),A,B); CHAT_SYS_FILELINENUMBERS('TRACE',PFORMAT_2(str diag_frameNo + ' ' + (MESSAGE),A,B))
	#define TRACE_CHAT_3(MESSAGE,A,B,C) TRACE_3((MESSAGE),A,B,C); CHAT_SYS_FILELINENUMBERS('TRACE',PFORMAT_3(str diag_frameNo + ' ' + (MESSAGE),A,B,C))
	#define TRACE_CHAT_4(MESSAGE,A,B,C,D) TRACE_4((MESSAGE),A,B,C,D); CHAT_SYS_FILELINENUMBERS('TRACE',PFORMAT_4(str diag_frameNo + ' ' + (MESSAGE),A,B,C,D))
	#define TRACE_CHAT_5(MESSAGE,A,B,C,D,E) TRACE_5((MESSAGE),A,B,C,D,E); CHAT_SYS_FILELINENUMBERS('TRACE',PFORMAT_5(str diag_frameNo + ' ' + (MESSAGE),A,B,C,D,E))
	#define TRACE_CHAT_6(MESSAGE,A,B,C,D,E,F) TRACE_6((MESSAGE),A,B,C,D,E,F); CHAT_SYS_FILELINENUMBERS('TRACE',PFORMAT_6(str diag_frameNo + ' ' + (MESSAGE),A,B,C,D,E,F))
	#define TRACE_CHAT_7(MESSAGE,A,B,C,D,E,F,G) TRACE_7((MESSAGE),A,B,C,D,E,F,G); CHAT_SYS_FILELINENUMBERS('TRACE',PFORMAT_7(str diag_frameNo + ' ' + (MESSAGE),A,B,C,D,E,F,G))
	#define TRACE_CHAT_8(MESSAGE,A,B,C,D,E,F,G,H) TRACE_8((MESSAGE),A,B,C,D,E,F,G,H); CHAT_SYS_FILELINENUMBERS('TRACE',PFORMAT_8(str diag_frameNo + ' ' + (MESSAGE),A,B,C,D,E,F,G,H))
	#define TRACE_CHAT_9(MESSAGE,A,B,C,D,E,F,G,H,I) TRACE_9((MESSAGE),A,B,C,D,E,F,G,H,I); CHAT_SYS_FILELINENUMBERS('TRACE',PFORMAT_9(str diag_frameNo + ' ' + (MESSAGE),A,B,C,D,E,F,G,H,I))
	#define TRACE_CHAT_10(MESSAGE,A,B,C,D,E,F,G,H,I,J) TRACE_10((MESSAGE),A,B,C,D,E,F,G,H,I,J); CHAT_SYS_FILELINENUMBERS('TRACE',PFORMAT_10(str diag_frameNo + ' ' + (MESSAGE),A,B,C,D,E,F,G,H,I,J))
#else
	#define TRACE_CHAT_1(MESSAGE,A) /* disabled */
	#define TRACE_CHAT_2(MESSAGE,A,B) /* disabled */
	#define TRACE_CHAT_3(MESSAGE,A,B,C) /* disabled */
	#define TRACE_CHAT_4(MESSAGE,A,B,C,D) /* disabled */
	#define TRACE_CHAT_5(MESSAGE,A,B,C,D,E) /* disabled */
	#define TRACE_CHAT_6(MESSAGE,A,B,C,D,E,F) /* disabled */
	#define TRACE_CHAT_7(MESSAGE,A,B,C,D,E,F,G) /* disabled */
	#define TRACE_CHAT_8(MESSAGE,A,B,C,D,E,F,G,H) /* disabled */
	#define TRACE_CHAT_9(MESSAGE,A,B,C,D,E,F,G,H,I) /* disabled */
	#define TRACE_CHAT_10(MESSAGE,A,B,C,D,E,F,G,H,I,J) /* disabled */
#endif
