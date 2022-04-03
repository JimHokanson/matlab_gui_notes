classdef uitable_wtf < handle
    %
    %
    %   Result:
    %   Approaches
    %   1) scroll 2021a+ - doesn't seem to work
    %   2) copy and delete - works but looks bad
    %       - 2020b - requires manual copying
    %   3) clearing data
    %       - 2020b - doesn't work
    %       - 2021b - similar to copying
    %

    %https://stackoverflow.com/questions/19634250/how-to-deselect-cells-in-uitable-how-to-disable-cell-selection-highlighting/19807210#19807210

    properties
        h_fig
        h_table matlab.ui.control.Table
    end

    methods
        function obj = uitable_wtf()
            obj.h_fig = uifigure();
            obj.h_table = uitable(obj.h_fig);
            n_rows = 1000;
            s = struct('a',num2cell(1:n_rows),'b',num2cell(1:n_rows));
            obj.h_table.Data = struct2table(s);
            try
                %Newer
                obj.h_table.SelectionChangedFcn = @obj.rowSelected;
            catch
                %Older
                obj.h_table.CellSelectionCallback = @obj.rowSelected;
            end
        end
        function rowSelected(obj,src,event)
            persistent count
            
            if isempty(count)
                count = 1;
            else
                count = count + 1;
            end
            
            try
                fprintf('%03d cell selected: [%d %d]\n',count,event.Selection(1),event.Selection(2))
            catch
                fprintf('%03d cell selected: [%d %d]\n',count,event.Indices(1),event.Indices(2))
            end
            
            %Initial display of blue before disappearing
            pause(0.3)
            
            APPROACH = 2;
            switch APPROACH
                case 1
                    %Doesn't make a selection ..
                    scroll(obj.h_table,"cell",[1,1])
                case 2
                    %copying
                    %Make sure you are using handle class
                    %legacy - copy callbacks
                    
                    %obj.h_table.Visible = 'off';
                    try
                        obj.h_table = copyobj(src,obj.h_fig,'legacy');
                    catch
                        %THIS SCROLLS
                        
                        %TODO: Demo for tab as well ...
                        %obj.h_table = uitable(obj.h_fig,'Visible','off');
                        obj.h_table = uitable(obj.h_fig,'Visible','on','Data',src.Data);
                        
%                         obj.h_table.Visible = 'off';
                        obj.h_table.Position = src.Position;
                        %obj.h_table.Data = src.Data;
                        obj.h_table.CellSelectionCallback = @obj.rowSelected;
%                         obj.h_table.Visible = 'on';
                        drawnow nocallbacks
                    end
                    pause(0.2);
                    %src.Visible = 'off';
                    %pause(3);
                    delete(src)
                    %obj.h_table.Visible = 'on';
                    %Not needed with 'legacy'
                    %obj.h_table.SelectionChangedFcn = @obj.rowSelected;
                case 3
                    %Data manipulation
                    d = obj.h_table.Data;
                    d2 = {};
                    %Visibility toggle doesn't appear to help
                    obj.h_table.Visible = 'off';
                    obj.h_table.Data = d2;
                    obj.h_table.Data = d;
                    obj.h_table.Visible = 'on';
            end
        end
    end
end