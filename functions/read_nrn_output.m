function res = read_nrn_output(file_dir)
fid = fopen(file_dir,'r'); %# open new csv file
res.variation_id = 0;
res.const_set = containers.Map();
res.param_set = containers.Map();
res.condition_list = containers.Map();
res.variable_names = {};
while ~feof(fid)
    parts = getNextLineParts();
    if isempty(parts)
        continue;
    end
    switch upper(parts{1})
        case 'VARIATION_ID'
            res.variation_id = str2double(parts{2});
        case 'START_CONST_PARAM'
            parts = getNextLineParts();
            while ~strcmpi(parts{1}, 'END_CONST_PARAM')
                switch upper(parts{2})
                    case 'CONST'
                        res.const_set(parts{3}) = str2double(parts{5});
                    case 'PARAM'
                        res.param_set(parts{3}) = str2double(parts{5});
                    otherwise
                        error('%s is not supposed to be in ''CONST_PARAM'' block', parts{2});
                end
                parts = getNextLineParts();
            end
            res.ntrials = res.const_set('NUM_TRIALS');
            res.nconds  = res.const_set('NUM_CONDITIONS');
            res.data = cell(res.nconds, res.ntrials);
        case 'START_CONDITION_LIST'
            parts = getNextLineParts('|');
            while ~strcmpi(parts{1}, 'END_CONDITION_LIST')
                sub_parts = returnNonEmpty(strsplit(parts{1}));
                if length(parts) < 2
                    comment_cond = '';
                else
                    comment_cond = parts{2};
                end
                res.condition_list(sub_parts{2}) = struct('index', str2double(sub_parts{1})+1,...
                    'comment', comment_cond);
                parts = getNextLineParts('|');
            end
        case 'VARIABLE_NAMES'
            res.variable_names = parts(2:end);
            res.spike_timings = cell(length(res.variable_names)-1,res.ntrials);
        case 'CONDITION'
            cond_ = res.condition_list(parts{2}).index;
        case 'TRIAL'
            trial_ = str2double(parts{2}) + 1;
        case 'START_SAMPLED_DATA'
            parts = getNextLineParts();
            
            nrows = str2double(parts{1});
            ncols = str2double(parts{2});
            format = [repmat('%f\t', 1, ncols), '%s'];
            dat_ = textscan(fid, format, nrows);
            dat_ = double([dat_{1:ncols}]);
            res.data{cond_, trial_} = dat_;
            
            parts = getNextLineParts();
            while isempty(parts)
                parts = getNextLineParts();
            end
            if strcmpi(parts{1}, 'END_SAMPLED_DATA')
                continue;
            end
        case 'START_SPIKE_TIMES'
            parts = getNextLineParts();
            while ~strcmpi(parts{1}, 'END_SPIKE_TIMES')
                if strcmpi(parts{1}, 'CELL')
                    cell_idx = str2double(parts{2})+1;
                   
                    nAPs = str2double(parts{5});
                    if nAPs == 0
                        res.spike_timings{cell_idx, cond_, trial_} = '';
                    else
                        
                        fgetl(fid) ; % skip
                        format = [repmat('%f\t', 1, nAPs), '%s'];
                        spkt_ = textscan(fid, format, 1);
                        spkt_ = double([spkt_{1:nAPs}]);
                        res.spike_timings{cell_idx, cond_, trial_} = spkt_;
                    end
                end
                parts = getNextLineParts();
            end
    end
end
fclose(fid);

    function parts_ = getNextLineParts(varargin)
        line = fgetl(fid);
        if nargin == 0
            splt = strsplit(line);
            parts_ = returnNonEmpty(splt);
            if isempty(parts_) && ~feof(fid)
                parts_ = getNextLineParts();
            end
        else
            parts_ = strsplit(line, varargin{1});
        end
    end
    function parts_ = returnNonEmpty(pa)
        parts_ = pa(cellfun(@(x_) ~isempty(x_), pa));
    end
end

