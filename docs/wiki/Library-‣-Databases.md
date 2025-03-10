### Functions

---

<!--ts-->
   * [close](#close)
   * [query](#query)
   * [open](#open)
<!--te-->

---


## close

#### Description

Close given database

#### Usage

<pre>
<b>close</b> <ins>database</ins> <i>:database</i>
</pre>

#### Returns

- *:nothing*

#### Examples

```red
db: open "my.db"    ; opens an SQLite database named 'my.db'
    
    print query db "SELECT * FROM users"

    close db            ; and close it
```

## query

#### Description

Execute command or block of commands in given database and get returned rows

#### Usage

<pre>
<b>query</b> <ins>database</ins> <i>:database</i>
      <ins>commands</ins> <i>:string</i> <i>:block</i>
</pre>
#### Attributes

|Attribute|Type|Description|
|---|---|---|
|id|<i>:boolean</i>|return last INSERT id|
|with|<i>:block</i>|use arguments for parametrized statement|

#### Returns

- *:null*
- *:integer*
- *:block*

#### Examples

```red
db: open "my.db"    ; opens an SQLite database named 'my.db'
    
    ; perform a simple query
    print query db "SELECT * FROM users"

    ; perform an INSERT query and get back the record's ID
    username: "johndoe"
    lastInsertId: query.id db ~{!sql INSERT INTO users (name) VALUES ('|username|')}

    ; perform a safe query with given parameters
    print query db .with: ["johndoe"] {!sql SELECT * FROM users WHERE name = ?}
```

## open

#### Description

Opens a new database connection and returns database

#### Usage

<pre>
<b>open</b> <ins>name</ins> <i>:string</i>
</pre>
#### Attributes

|Attribute|Type|Description|
|---|---|---|
|sqlite|<i>:boolean</i>|support for SQLite databases|
|mysql|<i>:boolean</i>|support for MySQL databases|

#### Returns

- *:database*

#### Examples

```red
db: open "my.db"    ; opens an SQLite database named 'my.db'
```