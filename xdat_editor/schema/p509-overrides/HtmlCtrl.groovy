package p509

import acmi.l2.clientmod.util.Description
import groovy.beans.Bindable
import groovy.transform.CompileDynamic

@Bindable
@CompileDynamic
class HtmlCtrl extends DefaultProperty {
    @Description("''/'Normal'/'Help'/'BBS'")
    String viewType

    int modernInt01
    String modernString01 = 'undefined'
    String modernString02 = 'undefined'
    String modernString03 = 'undefined'

    @Override
    HtmlCtrl read(InputStream input) {
        super.read(input)
        viewType = input.readString()
        modernInt01 = input.readInt()
        modernString01 = input.readString()
        modernString02 = input.readString()
        modernString03 = input.readString()
        this
    }

    @Override
    HtmlCtrl write(OutputStream output) {
        super.write(output)
        output.writeString(viewType)
        output.writeInt(modernInt01)
        output.writeString(modernString01)
        output.writeString(modernString02)
        output.writeString(modernString03)
        this
    }
}
