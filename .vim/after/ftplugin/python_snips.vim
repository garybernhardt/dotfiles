if !exists('loaded_snips') || exists('s:did_python_snips')
	fini
en
let s:did_python_snips = 1
let snippet_filetype = 'python'

" #!/usr/bin/python
exe "Snipp #! #!/usr/bin/python\n"
" True and False
exe "Snipp t True"
exe "Snipp f False"
" None
exe "Snipp n None"
" Self
exe "Snipp s self."
" Init function
exe "Snipp i def __init__(self, "
" While
exe "Snipp wh while ${1:condition}:\n\t${2:# code...}"
" New Class
exe "Snipp cl class ${1:ClassName}(${2:object}):\n\t\"\"\"${3:docstring for $1}\"\"\"\n\tdef __init__(self, ${4:arg}):\n\t\t${5:super($1, self).__init__()}\n\t\tself.$4 = $4\n\t\t${6}"
" New Function
exe "Snipp def def ${1:name}(${2:args}):\n\t${3:pass}"
" New Method
exe "Snipp defs def ${1:mname}(self, ${2:arg})):\n\t${3:pass}"
" New Property
exe "Snipp property def ${1:foo}():\n\tdoc = \"${2:The $1 property.}\"\n\tdef fget(self):\n\t\t\t${3:return self._$1}\n\tdef fset(self, value):\n\t\t"
\."${4:self._$1 = value}\n\tdef fdel(self):\n\t\t\t${5:del self._$1}\n\treturn locals()\n$1 = property(**$1())${6}"
" Self
exe 'Snipp . self.'
" Try/Except
exe "Snipp try try:\n\t${1:pass}\nexcept ${2:Exception}, ${3:e}:\n\t${4:raise $3}"
" Try/Except/Else
exe "Snipp trye try:\n\t${1:pass}\nexcept ${2:Exception}, ${3:e}:\n\t${4:raise $3}\nelse:\n\t${5:pass}"
" Try/Except/Finally
exe "Snipp tryf try:\n\t${1:pass}\nexcept ${2:Exception}, ${3:e}:\n\t${4:raise $3}\nfinally:\n\t${5:pass}"
" Try/Except/Else/Finally
exe "Snipp tryef try:\n\t${1:pass}\nexcept ${2:Exception}, ${3:e}:\n\t${4:raise $3}\nelse:\n\t${5:pass}\nfinally:\n\t${6:pass}"
" if __name__ == '__main__':
exe "Snipp ifmain if __name__ == '__main__':\n\t${1:main()}"
" __magic__
exe 'Snipp _ __${1:init}__${2}'
