# for *nix.
/~\/\.vim\/neobundle/ {
    match($0, /~\/\.vim\/neobundle\/([^/]+)\//, matched);
    if (scritps_name != matched[1])
    {
        ++n_scripts;
        scritps_name = matched[1];
        printf "[%03d] -- %s\n", n_scripts, scritps_name;
    }

    ++n_files;
    sub(/^.*~\/\.vim\/neobundle\/[^/]+\//, "\t./");
    print $0;
}

# for Windows.
/vimfiles\\neobundle/ {
    match($0, /vimfiles\\neobundle\\([^\\]+)\\/, matched);
    if (scritps_name != matched[1])
    {
        ++n_scripts;
        scritps_name = matched[1];
        printf "[%03d] -- %s\n", n_scripts, scritps_name;
    }

    ++n_files;
    sub(/^.*vimfiles\\neobundle\\[^\\]+\\/, "\t./");
    print $0;
}
END {
    print "\n\n=========================== Totally ===========================";
    printf "\n  %5d scritps loaded.\n  %5d files loaded.\n", n_scripts, n_files;
}
