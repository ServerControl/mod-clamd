use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'ServerControl-Clamd',
   VERSION_FROM => 'lib/ServerControl/Module/Clamd.pm',
   PREREQ_PM => {'ServerControl' => '0.100'},
   LICENSE => 'bsd'
);

