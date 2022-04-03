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
            s = struct('a',num2cell(1:4),'b',num2cell(5:8));
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
            try
                fprintf('cell selected: [%d %d]\n',event.Selection(1),event.Selection(2))
            catch
                fprintf('cell selected: [%d %d]\n',event.Indices(1),event.Indices(2))
            end

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
                        obj.h_table = uitable(obj.h_fig,'Position',src.Position);
                        obj.h_table.Data = src.Data;
                        obj.h_table.CellSelectionCallback = @obj.rowSelected;
                    end
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