package p509

import acmi.l2.clientmod.l2resources.Sysstr
import acmi.l2.clientmod.l2resources.Tex
import groovy.beans.Bindable
import groovy.transform.CompileDynamic

@Bindable
@CompileDynamic
class CheckBox extends DefaultProperty {
    @Sysstr int titleIndex = -1
    String titleText = 'undefined'
    Boolean checked
    Boolean leftAligned
    int maxWidth = -9999

    @Tex String checkTexture = 'undefined'
    @Tex String unCheckTexture = 'undefined'
    @Tex String disableTexture = 'undefined'
    @Tex String disableCheckTexture = 'undefined'

    int modernTail = -9999

    @Override
    CheckBox read(InputStream input) {
        super.read(input)
        titleIndex = input.readInt()
        titleText = input.readString()
        checked = input.readBoolean()
        leftAligned = input.readBoolean()
        maxWidth = input.readInt()
        checkTexture = input.readString()
        unCheckTexture = input.readString()
        disableTexture = input.readString()
        disableCheckTexture = input.readString()
        modernTail = input.readInt()
        this
    }

    @Override
    CheckBox write(OutputStream output) {
        super.write(output)
        output.writeInt(titleIndex)
        output.writeString(titleText)
        output.writeBoolean(checked)
        output.writeBoolean(leftAligned)
        output.writeInt(maxWidth)
        output.writeString(checkTexture)
        output.writeString(unCheckTexture)
        output.writeString(disableTexture)
        output.writeString(disableCheckTexture)
        output.writeInt(modernTail)
        this
    }
}
