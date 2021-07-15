function vr = getHidingTargetVertices_cyjs(vr)

    for worldNum = 1:4 % 1:4 are now our non-visually guided worlds
        objID = vr.worlds{worldNum}.objects.indices.targetSideWalls_hide;
        objVert = vr.worlds{worldNum}.objects.vertices(objID,:);
        cueVert = objVert(1):objVert(2);
        objID = vr.worlds{worldNum}.objects.indices.targetRearWall_hide;
        objVert = vr.worlds{worldNum}.objects.vertices(objID,:);
        cueVert = [cueVert, objVert(1):objVert(2)];
        vr.cueToHide{worldNum} = cueVert;
        objID = vr.worlds{worldNum}.objects.indices.targetSideWalls;
        objVert = vr.worlds{worldNum}.objects.vertices(objID,:);
        blankVert = objVert(1):objVert(2);
        objID = vr.worlds{worldNum}.objects.indices.targetRearWall;
        objVert = vr.worlds{worldNum}.objects.vertices(objID,:);
        blankVert = [blankVert, objVert(1):objVert(2)];
        vr.blankToHide{worldNum} = blankVert;
        vr.worlds{worldNum}.surface.vertices(2,vr.blankToHide{worldNum}) =...
            100 + vr.worlds{worldNum}.surface.vertices(2,vr.blankToHide{worldNum});
end