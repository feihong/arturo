######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2021 Yanis Zafirópulos
#
# @file: helpers/database.nim
######################################################

#=======================================
# Libraries
#=======================================

import sequtils, sqlite3, strutils

#import db_mysql as mysql
import db_sqlite as sqlite

import vm/values/value

#=======================================
# Types
#=======================================

type
    QueryResultKind* = enum
        EmptyQueryResult,
        ValidQueryResult

    QueryResult* = (QueryResultKind, ValueArray)

#=======================================
# Methods
#=======================================

#-----------------------
# MySQL
#-----------------------

# proc openMysqlDb*(name: string, 
#                   server: string = "localhost", 
#                   username: string = "", 
#                   password: string = ""): mysql.DbConn =
#     mysql.open(server, username, password, name)

# proc execMysqlDb*(db: mysql.DbConn, command: string) =
#     db.exec(sql(command))

# proc closeMysqlDb*(dbObj: mysql.DbConn) =
#     mysql.close(dbObj)

#-----------------------
# SQLite
#-----------------------

proc openSqliteDb*(name: string): sqlite.DbConn =
    sqlite.open(name, "", "", "")

proc execSqliteDb*(db: sqlite.DbConn, command: string, with: seq[string] = @[]): QueryResult =
    var ret: ValueArray = @[]

    #echo "executing SQL:" & $(command)

    for row in db.rows(sql(command), with):
        ret.add(newStringBlock(row))

    if ret.len>0 or command.toLowerAscii.contains("select"):
        result = (ValidQueryResult, ret)
    else:
        result = (EmptyQueryResult, ret)

proc execManySqliteDb*(db: sqlite.DbConn, commands: seq[string], with: seq[string] = @[]): QueryResult =
    var ret: ValueArray = @[]

    #echo "executing SQL:" & $(commands)

    db.exec(sql"BEGIN")

    for command in commands:
        ret = concat(ret, execSqliteDb(db, command, with)[1])

    db.exec(sql"COMMIT")

    result = (EmptyQueryResult, ret)

proc getLastIdSqliteDb*(db: sqlite.DbConn): int64 = 
    last_insert_rowid(db)

proc closeSqliteDb*(db: sqlite.DbConn) =
    sqlite.close(db)
