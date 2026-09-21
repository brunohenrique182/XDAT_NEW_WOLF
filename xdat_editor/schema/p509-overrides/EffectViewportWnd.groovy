package p509

import acmi.l2.clientmod.l2resources.Tex
import groovy.beans.Bindable
import groovy.transform.CompileDynamic

/**
 * Wolf Waker / p520 EffectViewportWnd.
 *
 * Reconstructed from 104 occurrences in the supplied Interface.xdat and
 * cross-checked with NWindow.EffectViewportWndHandle:
 * scale, Vector offset (X/Y/Z), camera distance, pitch/yaw,
 * background/mask textures and UI-sound flag.
 */
@Bindable
@CompileDynamic
class EffectViewportWnd extends DefaultProperty {
    float scale = 1.0f
    float offsetX
    float offsetY
    float offsetZ
    float cameraDistance = 250.0f
    int cameraPitch = -800
    int cameraYaw = 34000

    @Tex String backgroundTex = ''
    @Tex String maskTex = ''

    Boolean uiSound = false

    @Override
    EffectViewportWnd read(InputStream input) {
        super.read(input)

        scale = input.readFloat()
        offsetX = input.readFloat()
        offsetY = input.readFloat()
        offsetZ = input.readFloat()
        cameraDistance = input.readFloat()
        cameraPitch = input.readInt()
        cameraYaw = input.readInt()
        backgroundTex = input.readString()
        maskTex = input.readString()
        uiSound = input.readBoolean()

        this
    }

    @Override
    EffectViewportWnd write(OutputStream output) {
        super.write(output)

        output.writeFloat(scale)
        output.writeFloat(offsetX)
        output.writeFloat(offsetY)
        output.writeFloat(offsetZ)
        output.writeFloat(cameraDistance)
        output.writeInt(cameraPitch)
        output.writeInt(cameraYaw)
        output.writeString(backgroundTex)
        output.writeString(maskTex)
        output.writeBoolean(uiSound)

        this
    }
}
