package p509

import acmi.l2.clientmod.util.Type
import groovy.beans.Bindable
import groovy.transform.CompileDynamic

@Bindable
@CompileDynamic
class ScrollArea extends DefaultProperty implements Iterable<DefaultProperty> {
    int areaHeight

    int modernInt01
    int modernInt02
    String modernString01 = 'undefined'
    String modernString02 = 'undefined'
    String modernString03 = 'undefined'

    @Type(DefaultProperty.class)
    List<DefaultProperty> children = []

    @Override
    Iterator<DefaultProperty> iterator() { children.iterator() }

    @Override
    ScrollArea read(InputStream input) {
        super.read(input)
        areaHeight = input.readInt()
        modernInt01 = input.readInt()
        modernInt02 = input.readInt()
        modernString01 = input.readString()
        modernString02 = input.readString()
        modernString03 = input.readString()
        children = input.readList(DefaultProperty)
        this
    }

    @Override
    ScrollArea write(OutputStream output) {
        super.write(output)
        output.writeInt(areaHeight)
        output.writeInt(modernInt01)
        output.writeInt(modernInt02)
        output.writeString(modernString01)
        output.writeString(modernString02)
        output.writeString(modernString03)
        output.writeList(children)
        this
    }
}
