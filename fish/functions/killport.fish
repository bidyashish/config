function killport --description "Kill whatever is listening on the given TCP port"
    if test (count $argv) -eq 0
        echo "usage: killport <port>" >&2
        return 2
    end
    set -l pids (lsof -ti :$argv[1])
    if test -z "$pids"
        echo "No process listening on port $argv[1]"
        return 1
    end
    kill -9 $pids
    echo "Killed PID(s) $pids on port $argv[1]"
end
