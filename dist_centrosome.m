thresh_dist = 2;

D_Table = readtable('Results.csv');
D_Table_frame = D_Table{:,end};
nnz_D_Table_frame = nonzeros(D_Table_frame);
last_frame = nnz_D_Table_frame(end);

% plot in 3D
%for i = 1:last_frame
%    XYZ = find(D_Table{:,6} == i);
%    plot3(D_Table{XYZ,3},D_Table{XYZ,4},D_Table{XYZ,5},'o');
%    grid on;
%    axis([0 30 0 30 0 30]);
%    M(i) = getframe;
%end

for i = 1:last_frame
    clear XYZ;
    XYZ = find(D_Table{:,6} == i);
    CoordiXYZ = [D_Table{XYZ,3} D_Table{XYZ,4} D_Table{XYZ,5}];
    [R_XYZ C_XYZ] = size(XYZ);
    XYZchoose = 1:R_XYZ;

    if(R_XYZ>2)  % if detected maxima is more than 2
      V = nchoosek(XYZchoose,2);
      [R_V, ~] = size(V);
    
      % loop for num of detected maxima    
      % label 0 if paired maximas are close
      for j = 1:R_V
        % calculate euclid distances among maximas
        distXYZ = norm(CoordiXYZ(V(j,1),:) - CoordiXYZ(V(j,2),:));
        
        if(distXYZ < thresh_dist )
          CoordiXYZ(V(j,1),:) = mean([CoordiXYZ(V(j,1),:); CoordiXYZ(V(j,2),:)]);
          CoordiXYZ(V(j,2),:) = [0 0 0];
        end
      end

      % loop for num of detected maxima    
      % get distance if the paired maximas are not 0s
      for k = 1:R_V
        distXYZ = norm(CoordiXYZ(V(k,1),:) - CoordiXYZ(V(k,2),:));        
        if(sum(CoordiXYZ(V(k,1),:)) == 0 | sum(CoordiXYZ(V(k,2),:)) == 0)

        else
          distAmongMaxima(i,k) = distXYZ;
        end
      end
        
    end
end

Sort_distAmongMaxima = sort(distAmongMaxima,2,'Descend');
NonZ_SDAM = sum(Sort_distAmongMaxima);
axis_SDAM = sum(NonZ_SDAM > 0);

imagesc(Sort_distAmongMaxima(:,1:axis_SDAM));
colorbar;
xlabel('number of combinations');
ylabel('frame');
title('Sample1');
