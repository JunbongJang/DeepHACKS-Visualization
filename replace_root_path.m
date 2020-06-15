function replaced_path = replace_root_path(old_path)
    old_path_list = {'C:\Users\fanzhang\Dropbox (QCI)\QCI Team Folder\Kwonmoo\', 'C:\Users\fanzhang\Dropbox (QCI)\QCI Team Folder\HeeJune\', ...
        '\\research.wpi.edu\leelab\HeeJune\Image_Data\CyD_PtK1\', 'Z:\HeeJune\'};
    new_path_list = {'\\research.wpi.edu\leelab\QCI dropbox\Kwonmoo\','\\research.wpi.edu\leelab\QCI dropbox2\HeeJune (QCI)\', ...
        '\\research.wpi.edu\leelab\HeeJune\Image_Data\PtK1_CyD\','\\research.wpi.edu\leelab\HeeJune\'};
    
    
    replaced_path = old_path;
    for i = 1:length(old_path_list)
        replaced_path = strrep(replaced_path, old_path_list{1,i},new_path_list{1,i});
    end
    
end