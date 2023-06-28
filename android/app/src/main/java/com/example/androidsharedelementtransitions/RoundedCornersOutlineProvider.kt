package com.example.androidsharedelementtransitions

import android.graphics.Outline
import android.view.View
import android.view.ViewOutlineProvider

class RoundedCornersOutlineProvider: ViewOutlineProvider() {
    override fun getOutline(view: View, outline: Outline) {
       outline.setRoundRect(0,0, view.width, view.height, 30f)
    }
}