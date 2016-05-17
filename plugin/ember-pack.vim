function! PodsGoTo()
  let type = input('Target([c]ontroller, [r]oute, [t]emplate, [C]omponent): ')
  let folder = expand('%:p:h')
  let files = {
\   'c': 'controller.js',
\   'r': 'route.js',
\   't': 'template.hbs',
\   'C': 'component.js'
\ }
  execute ":edit " . folder . "/" . files[type]
endfunction

function! GetVisualSelection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

function! EmberTestSelectionFilter()
  let selection = GetVisualSelection()
  let execute = "ember t -sf '". selection . "'"
  execute ':call VimuxRunCommand("' . execute . '")'
endfunction

function! EmberRunNearest()
  execute ':silent normal! ?test?e' . "\r" . "vi'y"
  let test_name = @"
  let command = "ember t -sf '". test_name . "'"
  execute ':call VimuxRunCommand("'. command .'")'
endfunction

function! EmberTestModule(server)
  execute ':silent normal! gg'
  let isUnitOrAcceptance = search('module(\|moduleForAcceptance(')
  if isUnitOrAcceptance == 0
    " component
    execute ':silent normal! /moduleForComponent(/e' . "\r" . "f,f'vi'y"
  else
    "unit or acceptance
    execute ':silent normal! /module(\|moduleForAcceptance(/e' . "\r" . "vi'y"
  endif
  let runserver = a:server == 's' ? 's' : ''
  let content = @"
  let command = "ember t -".runserver."m '". content . "'"
  execute ':call VimuxRunCommand("'. command .'")'
endfunction

function! EmberTestGlobal()
  execute ':call VimuxRunCommand("ember t")'
endfunction
