videoObj=videoinput('winvideo',1,'RGB24_1280x960');
set(videoObj, 'SelectedSourceName', 'input1');
set(videoObj, 'FramesPerTrigger', 1);
preview(videoObj);
start(videoObj);

%frame = getsnapshot(videoObj);
image = getdata(videoObj);
imshow(image)
stop(videoObj);
delete(videoObj);