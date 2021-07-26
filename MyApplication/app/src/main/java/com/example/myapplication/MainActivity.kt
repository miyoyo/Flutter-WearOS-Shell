package com.example.myapplication

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.fragment.app.FragmentActivity
import androidx.wear.widget.SwipeDismissFrameLayout
import io.flutter.embedding.android.FlutterFragment
import io.flutter.plugin.common.MethodChannel

class MainActivity : FragmentActivity() {
    companion object {
        // Define a tag String to represent the FlutterFragment within this
        // Activity's FragmentManager. This value can be whatever you'd like.
        private const val TAG_FLUTTER_FRAGMENT = "flutter_fragment"
    }

    // Declare a local variable to reference the FlutterFragment so that you
    // can forward calls to it later.
    private var flutterFragment: FlutterFragment? = null

    private var swipeDismissFrameLayout: SwipeDismissFrameLayout? = null

    @SuppressLint("RestrictedApi")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Inflate a layout that has a container for your FlutterFragment. For
        // this example, assume that a FrameLayout exists with an ID of
        // R.id.fragment_container.
        setContentView(R.layout.activity_main)

        // Get a reference to the Activity's FragmentManager to add a new
        // FlutterFragment, or find an existing one.
        val fragmentManager = supportFragmentManager

        swipeDismissFrameLayout = findViewById(R.id.root)

        swipeDismissFrameLayout?.addCallback(object : SwipeDismissFrameLayout.Callback() {
            override fun onDismissed(layout: SwipeDismissFrameLayout?) {
                super.onDismissed(layout)
                layout?.visibility = View.GONE
                layout?.removeAllViewsInLayout()
                finish()
            }
        })

        // The Android documentation lies.
        // This setter is not available by default, you must ignore the lint error.
        swipeDismissFrameLayout?.isSwipeable = false

        // Attempt to find an existing FlutterFragment, in case this is not the
        // first time that onCreate() was run.
        flutterFragment = fragmentManager
            .findFragmentByTag(TAG_FLUTTER_FRAGMENT) as FlutterFragment?

        // Create and attach a FlutterFragment if one does not exist.
        if (flutterFragment == null) {
            var newFlutterFragment = FlutterFragment.createDefault()
            flutterFragment = newFlutterFragment
            fragmentManager
                .beginTransaction()
                .add(
                    R.id.root,
                    newFlutterFragment,
                    TAG_FLUTTER_FRAGMENT
                )
                .commit()
        }
    }

    @SuppressLint("RestrictedApi")
    override fun onPostResume() {
        super.onPostResume()
        flutterFragment!!.onPostResume()

        MethodChannel(
            flutterFragment!!.flutterEngine!!.dartExecutor, "io.flutter.wear").setMethodCallHandler { call, result ->
            when (call.method) {
                "allowSwipe" -> {
                    swipeDismissFrameLayout?.isSwipeable = true;

                    result.success(true)
                }
                "banSwipe" -> {
                    swipeDismissFrameLayout?.isSwipeable = false;
                    result.success(false)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        flutterFragment!!.onNewIntent(intent)
    }

    override fun onBackPressed() {
        flutterFragment!!.onBackPressed()
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String?>,
        grantResults: IntArray
    ) {
        flutterFragment!!.onRequestPermissionsResult(
            requestCode,
            permissions,
            grantResults
        )
    }

    override fun onUserLeaveHint() {
        flutterFragment!!.onUserLeaveHint()
    }

    override fun onTrimMemory(level: Int) {
        super.onTrimMemory(level)
        flutterFragment!!.onTrimMemory(level)
    }
}