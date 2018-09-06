export Signal, Slot, Connection

"""
Defines a signal which may be broadcast from a QObject. Looks like
a C++ function signature. E.g. we would represent the signal:

    add(int, int)

Like this:

    Signal("add", ["int", "int"])
"""
struct Signal
    name::String
    args::Vector{String}
end

Signal(name::AbstractString) = Signal(name, String[])

"""
Defines a slot on a QObject which may accept a broadcast signal.
Looks like a regular C++ function:

    add(int, int)

Like this:

    Slot("add", ["int", "int"])
"""
struct Slot
    name::String
    args::Vector{String}
end

Slot(name::AbstractString) = Slot(name, String[])

"""
Represent a connection between a signal emitted from an object
and a slot on a receiving object. This could be a push button emitting
a `clicked()` signal, which you want to connect to a `handleButtonClick()`
slot on receiver object.
"""
mutable struct Connection
    sender::String
    signal::Signal
    receiver::String
    slot::Slot
end

##################### IO #####################

print(io::IO, signal::Signal) = print(io, signal.name, "(", join(signal.args, ", "),")")
print(io::IO, slot::Slot)     = print(io, slot.name,   "(", join(slot.args,   ", "),")")

##################### XML #####################
"""
    xml(connection)
Create an XML representation of a Qt connection between signal and slot
of a sender and receiver.
"""
function xml(conn::Connection)
    node = ElementNode("connection")
    addchildren!(node, [
        "sender" => conn.sender,
        "signal" => string(conn.signal),
        "receiver" => conn.receiver,
        "slot" => string(conn.slot)])
    node
end

function connection(sender::String, signal::Signal, receiver::String, slot::Slot)
    xml(Connection(sender, signal, receiver, slot))
end

"""
    xml(connections)
XML representation for multiple connections.
"""
function xml(conns::Vector{Connection})
    node = ElementNode("connections")
    for conn in conns
        addchild!(node, xml(conn))
    end
    node
end

function connections(conns...)
    p = ElementNode("connections")
    for conn in conns
        addchild!(p, conn)
    end
    p
end
