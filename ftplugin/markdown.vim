function! Extract()
  let l:tmp_lines = []
  let l:cline_n = 1
  while l:cline_n < 100 " arbitrary, but no sense in having huge yaml headers either
    let l:cline = getline(l:cline_n)
    let l:is_delim = l:cline =~ '^[-.]\{3}'
    if l:cline_n == 1 && !l:is_delim " assume no header, end early
      return []
    elseif l:cline_n > 1 && l:is_delim " yield data as soon as we find a delimiter
      return l:tmp_lines
    else
      if l:cline_n > 1
        call add(l:tmp_lines, l:cline)
      endif
    endif
    let l:cline_n += 1
  endwhile
  return [] " just in case
endfunction

function! Parse(...)
  if a:0 == 0 " if no arguments, extract from the current buffer
    let l:block = Extract()
  else
    let l:block = a:1
  endif
  if l:block == []
    return -1
  endif
  let yaml_dict = {}
  " assume a flat structure
  for line in l:block
    let key = ''
    let val = ''
    try
      let [key, val] = matchlist(line,
            \ '\s*\([[:graph:]]\+\)\s*:\s*\([[:graph:]]\+\)\s*')[1:2]
      let key = substitute(key, '[ -]', '_', 'g')
      let yaml_dict[key] = val
    catch
    endtry
  endfor
  return yaml_dict
endfunction au!

function! PandocCompile()
  let headers=Parse()
  let file=@%
  let out=substitute(file, "md$", "pdf", "")
  let command="!pandoc " . file . " -o " . out  . " --template " . headers["template"] . " -N"
  echo(command)
  silent! execute(command)
endfunction

nnoremap <Leader>tt :call PandocCompile()<CR>

function! OpenPDF()
  let file=@%
  let out=substitute(file, "md$", "pdf", "")
  let command="!open -a Skim " . out
  echo(command)
  silent! execute(command)
endfunction

nnoremap <Leader>ts :call OpenPDF()<CR>
