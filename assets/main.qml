import bb.cascades 1.0
import bb.data 1.0
import bb.system 1.0
import my.library 1.0

NavigationPane {
    id: npMain
	Page {
	    onCreationCompleted: {
	        dsData.load()
	    }
	    Container {
	        layout: DockLayout {
	            
	        }
	        ListView {
	            onTriggered: {
                	var page = cdDetails.createObject()
                	page.info = dataModel.data(indexPath)
                	npMain.push(page)
                }
	            dataModel: ArrayDataModel {
	                id: admModel
	            }
	            function itemType(data, indexPath){
	                return "item"
	            }
	            listItemComponents: [
	                ListItemComponent {
	                    type: "item"
	                    Container {
	                     	topPadding: 20
		                    Container {
		                        layout: StackLayout {
		                            orientation: LayoutOrientation.LeftToRight
		                        }
		                        leftPadding: 20
		                        rightPadding: 20
		                        Container {	
		                            layout: DockLayout {                                
		                            }  
		                            minHeight: 200
		                            minWidth: 200 
		                            maxHeight: 200
		                            maxWidth: 200  
		                            WebImageView {
		                                id: wivImage
		                                url: ListItemData.enclosure.url
		                                scalingMethod: ScalingMethod.AspectFill                                    
		                                defaultImage: "asset:///images/loader.jpg"   
		                                horizontalAlignment: HorizontalAlignment.Fill
		                                verticalAlignment: VerticalAlignment.Fill                   
		                            }
			                        ProgressIndicator {
			                            preferredWidth: 100
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
		                        Container {
		                            leftPadding: 20
		                            Label {
		                               text:  ListItemData.title
		                               multiline: true
		                            }
		                        }
		                    }
		                    Container {
		                        topPadding: 20
	                        	Divider {
	                         	} 
	                        }
		                }
	                }
	            ]
	        }
	        ActivityIndicator {
	            id: aiData
	            preferredHeight: 200
	            preferredWidth: 200
	            running: true
	            horizontalAlignment: HorizontalAlignment.Center
	            verticalAlignment: VerticalAlignment.Center
	        }
	    }
	    attachedObjects: [
	        DataSource {
	            id: dsData
	            type: DataSourceType.Xml
	            query: "channel/item"
	            source: "http://www.nasa.gov/rss/dyn/image_of_the_day.rss"
	            onDataLoaded: {
	                aiData.stop()
	                admModel.clear()
	                admModel.append(data)
	            }
	            onError: {
	                aiData.stop()
	                sdError.body = "There was an error while trying to retrieve data:\n" + errorMessage
	                sdError.show()
	            }
	        },
	        SystemDialog {
	            id: sdError      
	            title: "WIVExample"       
	        }
	    ]
	}
	attachedObjects: [
	    ComponentDefinition {
        	id: cdDetails
        	source: "details.qml" 
        }
	]
}