function __fish_crenv_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 -a $cmd[1] = 'crenv' ]
    return 0
  end
  return 1
end

function __fish_crenv_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

complete -f -c crenv -n '__fish_crenv_needs_command' -a '(crenv commands)'
for cmd in (crenv commands)
  complete -f -c crenv -n "__fish_crenv_using_command $cmd" -a "(crenv completions $cmd)"
end
