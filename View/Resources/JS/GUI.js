// JavaScript Document
imageGalleryController={
	arGallery:[],
	imageLoading:new Image(),
	preloadGalleryImages:function(){
		var baseSrc="";
		var image=new Image();
		var gallery={};
		
		if(this.arGallery.length>0 && this.arGallery[0].arImages.length>0){
			// preload "image loading..." image
			baseSrc=this.getBaseSrcFromImage(this.arGallery[0].arImages[0]);
			this.imageLoading.src=baseSrc+"image_loading.png";
			// load the image off screen
			this.imageLoading.style.position="absolute";
			this.imageLoading.style.display="none";
			document.body.appendChild(this.imageLoading);
		}
		
		for(var i in this.arGallery){
			gallery=this.arGallery[i];
			
			for(var j in gallery.arImages){
				image=gallery.arImages[j];
				
				// load the image off screen
				image.style.position="absolute";
				image.style.display="none";
				document.body.appendChild(image);
			}
		}
	},
	setImage:function(displayImageId,offScreenImageId,maxDimension){
		var width=0;
		var height=0;
		var divider=0;
		var displayImage=document.getElementById(displayImageId);
		var offScreenImage=document.getElementById(offScreenImageId);
		
		if(offScreenImage.complete){
		
			// retrieve off new image dimensions
			width=offScreenImage.width;
			height=offScreenImage.height;
			
			if(maxDimension>0 && (width>maxDimension || height>maxDimension)){
				// scale image dimensions
				if(width>=height){
					divider=width/maxDimension;
				}
				else{
					divider=height/maxDimension;
				}
				
				width=Math.round(width/divider);
				height=Math.round(height/divider);
			}
			
			// set the attributes of the display image to the new image
			displayImage.src="";
			displayImage.src=offScreenImage.src;
			displayImage.width=width;
			displayImage.height=height;
		
		}
		else{
			// the image off screen image is still loading
			displayImage.src="";
			displayImage.src=this.imageLoading.src;
			displayImage.width=this.imageLoading.width;
			displayImage.height=this.imageLoading.height;
		}
	},
	getBaseSrcFromImage:function(image){
		var from=0;
		var to=image.src.lastIndexOf("/")+1;
		var baseSrc=image.src.substring(from,to);
		
		return baseSrc;
	},
	imagePrevious:function(galleryId){
		alert("previous for "+galleryId);
		
	},
	imageNext:function(galleryId){
		alert("Next for "+galleryId);
	},
	slideShowStart:function(galleryId){
		alert("Start slide show for "+galleryId);
	}
};