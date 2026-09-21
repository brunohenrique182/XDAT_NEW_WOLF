package p509

import acmi.l2.clientmod.l2resources.Sysstr
import acmi.l2.clientmod.l2resources.Tex
import acmi.l2.clientmod.util.Description
import groovy.beans.Bindable
import groovy.transform.CompileDynamic

/**
 * Wolf/p509 Button layout reconstructed from the target Interface.xdat.
 *
 * Compared with etoa5:
 * - one extra String is present after dropTex;
 * - two extra 32-bit values are present after disableTex.
 *
 * Unknown fields are preserved for safe read/write round trips.
 */
@Bindable
@CompileDynamic
class Button extends DefaultProperty {
    @Tex String normalTex = 'undefined'
    @Tex String pushedTex = 'undefined'
    @Tex String highlightTex = 'undefined'
    @Tex String dropTex = 'undefined'

    String modernString01 = 'undefined'

    @Sysstr int buttonName = -9999
    String buttonNameText = 'undefined'
    Boolean noHighlight
    Boolean defaultSoundOn

    @Description('-9999/5000')
    int disableTime = -9999

    @Tex String disableTex = 'undefined'

    int modernColor01
    int modernColor02

    @Override
    Button read(InputStream input) {
        super.read(input)

        normalTex = input.readString()
        pushedTex = input.readString()
        highlightTex = input.readString()
        dropTex = input.readString()
        modernString01 = input.readString()

        buttonName = input.readInt()
        buttonNameText = input.readString()
        noHighlight = input.readBoolean()
        defaultSoundOn = input.readBoolean()
        disableTime = input.readInt()
        disableTex = input.readString()

        modernColor01 = input.readInt()
        modernColor02 = input.readInt()

        this
    }

    @Override
    Button write(OutputStream output) {
        super.write(output)

        output.writeString(normalTex)
        output.writeString(pushedTex)
        output.writeString(highlightTex)
        output.writeString(dropTex)
        output.writeString(modernString01)

        output.writeInt(buttonName)
        output.writeString(buttonNameText)
        output.writeBoolean(noHighlight)
        output.writeBoolean(defaultSoundOn)
        output.writeInt(disableTime)
        output.writeString(disableTex)

        output.writeInt(modernColor01)
        output.writeInt(modernColor02)

        this
    }
}
