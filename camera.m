videoObj=videoinput('winvideo',1,'RGB24_1280x960');
set(videoObj, 'SelectedSourceName', 'input1');
set(videoObj, 'FramesPerTrigger', 1);
start(videoObj);
image = getdata(videoObj);
imshow(image);
imwrite(image, 'board_empty.png');
stop(videoObj);
delete(videoObj);