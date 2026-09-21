package p509

import acmi.l2.clientmod.l2resources.Tex
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.beans.Bindable
import groovy.transform.CompileDynamic

/**
 * Wolf Waker / p520 CharacterViewportWindow.
 *
 * The p520 binary layout extends the etoa5 structure with two 32-bit
 * values after npcID/userInfo. This is confirmed at BalrogWnd.ObjectViewport:
 * without these fields the next child class is read 8 bytes early; consuming
 * them aligns exactly on the following Texture entity.
 */
@Bindable
@DefaultIO
@CompileDynamic
class CharacterViewportWindow extends DefaultProperty {
    float characterScale = 1f
    int characterOffsetX = -2
    int characterOffsetY = -6
    int cameraDistMax = 300
    int cameraDistMin = 250
    int defaultCameraPitch = -800
    int defaultCameraYaw = 34000
    int zoomRate = 3
    int rotationRate = 700

    @Tex String backgroundTex
    @Tex String maskTex

    int npcID
    int userInfo

    int modernTail01
    int modernTail02
}
