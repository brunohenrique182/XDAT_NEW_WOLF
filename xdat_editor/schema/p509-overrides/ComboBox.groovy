package p509

import acmi.l2.clientmod.l2resources.Sysstr
import acmi.l2.clientmod.util.IOEntity
import acmi.l2.clientmod.util.Type
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.beans.Bindable

@Bindable
class ComboBox extends DefaultProperty {
    @Type(ComboBoxElement.class)
    List<ComboBoxElement> values = []

    int modernTail

    @Bindable
    @DefaultIO
    static class ComboBoxElement implements IOEntity {
        @Sysstr int sysString = -9999
        int systemMsg = -9999
        String text = 'undefined'
        int reserved = -9999

        @Override
        String toString() { getClass().simpleName }
    }

    @Override
    ComboBox read(InputStream input) {
        super.read(input)
        values = input.readList(ComboBoxElement)
        modernTail = input.readInt()
        this
    }

    @Override
    ComboBox write(OutputStream output) {
        super.write(output)
        output.writeList(values)
        output.writeInt(modernTail)
        this
    }
}
