### Functions

---

<!--ts-->
   * [copy](#copy)
   * [delete](#delete)
   * [exists?](#exists?)
   * [permissions](#permissions)
   * [read](#read)
   * [rename](#rename)
   * [symlink](#symlink)
   * [unzip](#unzip)
   * [write](#write)
   * [zip](#zip)
<!--te-->

---


## copy

#### Description

Copy file at path to given destination

#### Usage

<pre>
<b>copy</b> <ins>file</ins> <i>:string</i>
     <ins>destination</ins> <i>:string</i>
</pre>
#### Attributes

|Attribute|Type|Description|
|---|---|---|
|directory|<i>:boolean</i>|path is a directory|

#### Returns

- *:nothing*

#### Examples

```red
copy "testscript.art" normalize.tilde "~/Desktop/testscript.art"
; copied file

copy "testfolder" normalize.tilde "~/Desktop/testfolder"
; copied whole folder
```

## delete

#### Description

Delete file at given path

#### Usage

<pre>
<b>delete</b> <ins>file</ins> <i>:string</i>
</pre>
#### Attributes

|Attribute|Type|Description|
|---|---|---|
|directory|<i>:boolean</i>|path is a directory|

#### Returns

- *:nothing*

#### Examples

```red
delete "testscript.art"
; file deleted
```

## exists?

#### Description

Check if given file exists

#### Usage

<pre>
<b>exists?</b> <ins>file</ins> <i>:string</i>
</pre>
#### Attributes

|Attribute|Type|Description|
|---|---|---|
|directory|<i>:boolean</i>|check for directory|

#### Returns

- *:boolean*

#### Examples

```red
if exists? "somefile.txt" [ 
    print "file exists!" 
]
```

## permissions

#### Description

Check permissions of given file

#### Usage

<pre>
<b>permissions</b> <ins>file</ins> <i>:string</i>
</pre>
#### Attributes

|Attribute|Type|Description|
|---|---|---|
|set|<i>:dictionary</i>|set using given file permissions|

#### Returns

- *:null*
- *:dictionary*

#### Examples

```red
inspect permissions "bin/arturo"
; [ :dictionary
;     user    :	[ :dictionary
;         read     :		true :boolean
;         write    :		true :boolean
;         execute  :		true :boolean
;     ]
;     group   :	[ :dictionary
;         read     :		true :boolean
;         write    :		false :boolean
;         execute  :		true :boolean
;     ]
;     others  :	[ :dictionary
;         read     :		true :boolean
;         write    :		false :boolean
;         execute  :		true :boolean
;     ]
; ]

permissions.set:#[others:#[write:true]] "bin/arturo"
; gave write permission to 'others'
```

## read

**Alias:** `<<`

#### Description

Read file from given path

#### Usage

<pre>
<b>read</b> <ins>file</ins> <i>:string</i>
</pre>
#### Attributes

|Attribute|Type|Description|
|---|---|---|
|lines|<i>:boolean</i>|read file lines into block|
|json|<i>:boolean</i>|read Json into value|
|csv|<i>:boolean</i>|read CSV file into a block of rows|
|withHeaders|<i>:boolean</i>|read CSV headers|
|html|<i>:boolean</i>|read HTML file into node dictionary|
|markdown|<i>:boolean</i>|read Markdown and convert to HTML|
|toml|<i>:boolean</i>|read TOML into value|
|binary|<i>:boolean</i>|read as binary|

#### Returns

- *:string*
- *:binary*
- *:block*

#### Examples

```red
; reading a simple local file
str: read "somefile.txt"

; also works with remote urls
page: read "http://www.somewebsite.com/page.html"

; we can also "read" JSON data as an object
data: read.json "mydata.json"

; or even convert Markdown to HTML on-the-fly
html: read.markdown "## Hello"     ; "<h2>Hello</h2>"
```

## rename

#### Description

Rename file at path using given new path name

#### Usage

<pre>
<b>rename</b> <ins>file</ins> <i>:string</i>
       <ins>name</ins> <i>:string</i>
</pre>
#### Attributes

|Attribute|Type|Description|
|---|---|---|
|directory|<i>:boolean</i>|path is a directory|

#### Returns

- *:nothing*

#### Examples

```red
rename "README.md" "READIT.md"
; file renamed
```

## symlink

#### Description

Create symbolic link of file to given destination

#### Usage

<pre>
<b>symlink</b> <ins>file</ins> <i>:string</i>
        <ins>destination</ins> <i>:string</i>
</pre>
#### Attributes

|Attribute|Type|Description|
|---|---|---|
|hard|<i>:boolean</i>|create a hard link|

#### Returns

- *:nothing*

#### Examples

```red
symlink relative "arturo/README.md" 
        "/Users/drkameleon/Desktop/gotoREADME.md"
; creates a symbolic link to our readme file
; in our desktop

symlink.hard relative "arturo/README.md" 
        "/Users/drkameleon/Desktop/gotoREADME.md"
; hard-links (effectively copies) our readme file
; to our desktop
```

## unzip

#### Description

Unzip given archive to destination

#### Usage

<pre>
<b>unzip</b> <ins>destination</ins> <i>:string</i>
      <ins>original</ins> <i>:string</i>
</pre>

#### Returns

- *:nothing*

#### Examples

```red
unzip "folder" "archive.zip"
```

## write

**Alias:** `>>`

#### Description

Write content to file at given path

#### Usage

<pre>
<b>write</b> <ins>file</ins> <i>:null</i> <i>:string</i>
      <ins>content</ins> <i>:any</i>
</pre>
#### Attributes

|Attribute|Type|Description|
|---|---|---|
|directory|<i>:boolean</i>|create directory at path|
|json|<i>:boolean</i>|write value as Json|
|binary|<i>:boolean</i>|write as binary|

#### Returns

- *:nothing*

#### Examples

```red
; write some string data to given file path
write "somefile.txt" "Hello world!"

; we can also write any type of data as JSON
write.json "data.json" myData
```

## zip

#### Description

Zip given files to file at destination

#### Usage

<pre>
<b>zip</b> <ins>destination</ins> <i>:string</i>
    <ins>files</ins> <i>:block</i>
</pre>

#### Returns

- *:nothing*

#### Examples

```red
zip "dest.zip" ["file1.txt" "img.png"]
```