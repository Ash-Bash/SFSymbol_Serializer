//
//  EditorTabletSplitView.swift
//  Icon Studio
//
//  Created by Ashley Chapman on 13/06/2022.
//

#if os(iOS)
import SwiftUI
import UIKit

struct EditorTabletSplitView: UIViewControllerRepresentable {
    
    // variables
    @ViewBuilder var canvasView: AnyView
    @ViewBuilder var inspectorView: AnyView
    
    init(canvas: AnyView, inspector: AnyView) {
        self.canvasView = canvas
        self.inspectorView = inspector
    }
    
    func makeUIViewController(context: Context) -> UIViewController {

        let inspectorNavView = UINavigationController(rootViewController: UIHostingController(rootView: self.inspectorView))
        inspectorNavView.navigationBar.isHidden = true
        let splitView = UISplitViewController(style: .doubleColumn)
        splitView.viewControllers = [inspectorNavView, UIHostingController(rootView: self.canvasView)]
        splitView.primaryEdge = .trailing
        splitView.navigationController?.navigationBar.isHidden = true
        
        return splitView
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

    }
}
#endif

