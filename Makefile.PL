use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Unicode::IMAPUtf7',
    'VERSION_FROM' => 'lib/Unicode/IMAPUtf7.pm', # finds $VERSION
    'PREREQ_PM'     => { 'Unicode::String' => 0 },
    'dist'          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);
