
{.$DEFINE USE_STATIC_SQLITE3}

{.$DEFINE ENABLE_ZEOS_DBMS}
{$DEFINE ENABLE_ODBC_DBMS}

{$IF DEFINED(ENABLE_ZEOS_DBMS) OR DEFINED(ENABLE_ODBC_DBMS)}
  {$DEFINE ENABLE_DBMS}
{$IFEND}

{$IFDEF DEBUG}

  {.$DEFINE SQL_LOG_ENABLE}
  
  {$IFDEF SQL_LOG_ENABLE}
    
    {.$DEFINE SQL_LOG_VERBOSE}
    
    {$IFDEF SQL_LOG_VERBOSE}
      {$DEFINE SQL_LOG_CACHE_RESULT}
      {$DEFINE SQL_LOG_CACHE_ENTER}
    {$ENDIF}
    
    {$DEFINE SQL_LOG_CACHE_SIZE}
    
  {$ENDIF}
  
{$ENDIF}