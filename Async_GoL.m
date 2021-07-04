function [Aout,mis] = Async_GoL(Am) %Am = 2D array in m generation
    % Uniform state coding
    % 0     -> 0
    % 0'    -> 1
    % (0,0) -> 2
    % (1,0) -> 3
    % (0,1) -> 4
    % (1,1) -> 5 
    % 1'    -> 6
    % 1     -> 7
    mis = 0;
    h = size(Am, 1);
    w = size(Am, 2);
    
	Ams = zeros(h+2,w+2);
    Anext = zeros(h+2,w+2);
    Ams(2:h+1, 2:w+1) = Am;
    
    for i = 2:h+1
        for j = 2:w+1
            %check q neighborhood states
%             q = zeros(1,8);
            q(1)   = Ams(i-1,j-1);
            q(2)   = Ams(i-1,j);
            q(3)   = Ams(i-1,j+1);
            q(4)   = Ams(i,j-1);
            cell   = Ams(i,j);
            q(5)   = Ams(i,j+1);
            q(6)   = Ams(i+1,j-1);
            q(7)   = Ams(i+1,j);
            q(8)   = Ams(i+1,j+1);
            cellIn = cell;
            
			%PHASE 1
            %No neighboring cell is in the succession state
			Scount = 0;
			for k = 1:8
				if(q(k)~=1 && q(k)~=6)
					Scount = Scount + 1;
				end
			end
            if(Scount == 8)
                %A cell in state 7 changes its state to 5 if two or three 
                %of the neighboring cells are in state 7, 3, or 5; 
                %otherwise the cell changes its state to 3.
                if(cell == 7)
					count = 0;
                    for k = 1:8
						if(q(k) == 7 || q(k) == 3 || q(k) == 5) 
                            count=count+1;
                        end
					end
                    if (count == 2 || count == 3)
						cell = 5;
					else
                        cell = 3;
                    end
                end
				
				%A cell in state 0 changes its state to state 4 if three of 
				%the neighboring cells are in state 7, 3, or 5; 
				%otherwise it changes its state to 2, except when the eight 
				%neighboring cells are all in state 0
                if(cell == 0)
					count  = 0;
					Zcount = 0;
                    for k = 1:8
						if(q(k) == 7 || q(k) == 3 || q(k) == 5) 
                            count = count+1;
                        end
						if(q(k) == 0)
							Zcount = Zcount+1;
						end
					end
                    if (count == 3)
						cell = 4;
% 					elseif (Zcount == 8)
%                         cell = cell
					elseif (Zcount ~= 8)
						cell = 2;
                    end
                end
				
            end
            
            %PHASE 2
            %A cell in intermediate state 2 or 3 changes its state to 1
            %if no neighboring cell is 0 or 7. A cell in 
            %intermediate state 4 or 5 changes its state to 6 if no 
            %neighboring cell is 0 or 7.
			
			Bcount = 0;
			for k = 1:8
				if(q(k)~=0 && q(k)~=7)
					Bcount = Bcount + 1;
				end
            end
            
			if(Bcount==8)
				if(cell == 2 || cell == 3)
					cell = 1;
				elseif(cell == 4 || cell == 5)
					cell = 6;
                end
            end
            
            %PHASE 3
			%A cell in succession state 1 (resp. 6) changes its 
			%state to 0 (resp. 7) if no neighboring cell is in the
			%intermediate state.
			Icount = 0;
			for k = 1:8
				if(q(k) >= 6 || q(k) <=1) %not in interm. state
					Icount = Icount + 1;
				end
			end
			
			if(cell == 1 && Icount == 8)
				cell = 0;
			end
			if(cell == 6 && Icount == 8)
				cell = 7;
			end

            
%             %NEXT STATE ASSIGNMENT
%             Anext(i-1,j-1) = q(1);
%             Anext(i-1,j  ) = q(2);
%             Anext(i-1,j+1) = q(3);
%             Anext(i  ,j-1) = q(4);
            Anext(i  ,j  ) = cell;
			
            if(cellIn~=cell)
                mis = mis +1;
            end
%             Anext(i  ,j+1) = q(5);
%             Anext(i+1,j-1) = q(6);
%             Anext(i+1,j  ) = q(7);
%             Anext(i+1,j+1) = q(8);
        end
    end
%     mis
    Aout = Anext(2:h+1,2:w+1);
end
