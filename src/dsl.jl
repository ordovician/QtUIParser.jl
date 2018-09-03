export @vbox

function entries_from_expression end

macro vbox(body::Expr)
   # entries_from_expression(body)
   BoxLayout("empty", vertical, Union{Layout, Widget}[])
end

function entries_from_expression(body::Expr)
    vars = filter(exp->!isa(exp, LineNumberNode), body.args)
    map(vars) do var
        if var.head == :(=)
            EnumValue(var.args[1], string(var.args[2]))
        else
            EnumValue(var, lowercase(var))
        end
    end
end