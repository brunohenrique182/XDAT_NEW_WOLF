package p509

import groovy.beans.Bindable
import groovy.transform.CompileDynamic

@Bindable
@CompileDynamic
class ShortcutItemWindow extends DefaultProperty {
    Boolean alwaysShowOutline = false
    Boolean useReservedShortcut = false

    int modernTail01
    int modernTail02

    @Override
    ShortcutItemWindow read(InputStream input) {
        super.read(input)
        alwaysShowOutline = input.readBoolean()
        useReservedShortcut = input.readBoolean()
        modernTail01 = input.readInt()
        modernTail02 = input.readInt()
        this
    }

    @Override
    ShortcutItemWindow write(OutputStream output) {
        super.write(output)
        output.writeBoolean(alwaysShowOutline)
        output.writeBoolean(useReservedShortcut)
        output.writeInt(modernTail01)
        output.writeInt(modernTail02)
        this
    }
}
