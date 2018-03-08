" Compiles the current markdown file
function! PandocCompile()
  let command=s:PandocCommand()
  echo(command)
  silent! execute(command)
endfunction


" Open the compiled PDF in Skim
function! OpenPDF()
  let command="!open -a Skim " . s:PdfName()
  echo(command)
  silent! execute(command)
endfunction

" Mappings
nnoremap <Leader>tt :call PandocCompile()<CR>
nnoremap <Leader>ts :call OpenPDF()<CR>

" === local functions ===

" Returns the name of the pdf that matches the first argument of the current file
function! s:PdfName(...)
  if a:0 == 0 " If no arguments, use current file
    let l:file = @%
  else
    let l:file = a:1
  endif
  return substitute(l:file, "md$", "pdf", "")
endfunction

function! s:PandocCommand()
  let s:headers=s:Parse()
  let s:input=@%
  let s:command=["!clear", "&&", "!pandoc", s:input, "-o", s:PdfName(s:input)]
  if has_key(s:headers, "template")
    call add(s:command, "--template")
    call add(s:command, s:headers["template"])
  endif
  if !has_key(s:headers, "numbersections") || s:headers["numbersections"] ==? "true"
    call add(s:command, "-N")
  end
  return join(s:command)
endfunction

" Returns an array with all the YAML Headers as strings
function! s:Extract()
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

" s:Parses the YAML Headers into a dict
function! s:Parse(...)
  if a:0 == 0 " if no arguments, extract from the current buffer
    let l:block = s:Extract()
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
