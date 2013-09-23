import bb.cascades 1.0
import my.library 1.0
Page {
    property variant info
    ScrollView {
    
	    Container {
	        leftPadding: 20
	        topPadding: 20
	        rightPadding: 20
	        bottomPadding: 20
	        Label {
	            text: info.title
	            multiline: true
	            textStyle.fontSize: FontSize.Large
	            
	        }
	        Container {	
	            layout: DockLayout {                                
	            }  
	            minHeight: 600
	            minWidth: 600 
	            maxHeight: 600
	            maxWidth: 600  
                horizontalAlignment: HorizontalAlignment.Center
	            WebImageView {
	                id: wivImage
	                url: info.enclosure.url
	                scalingMethod: ScalingMethod.AspectFit                                    
	                defaultImage: "asset:///images/loader.jpg"   
	                horizontalAlignment: HorizontalAlignment.Fill
	                verticalAlignment: VerticalAlignment.Fill                   
	            }
	            ProgressIndicator {
	                preferredWidth: 200
	                horizontalAlignment: HorizontalAlignment.Center
	                verticalAlignment: VerticalAlignment.Center
	                fromValue: 0
	                toValue: 1
	                value: wivImage.loading
	                visible: value != 0 && value != 1 
	            }
	            /*
	             //Another option instead ProgressIndicator
	             ActivityIndicator {
	             preferredHeight: 50
	             preferredWidth: 50
	             horizontalAlignment: HorizontalAlignment.Center
	             verticalAlignment: VerticalAlignment.Center
	             running: wivImage.loading != 0 && wivImage.loading != 1
	             }
	             */
	        }
	        Label {
	            multiline: true
	            text: info.description 
	                
	        }
	    }
	}
}
