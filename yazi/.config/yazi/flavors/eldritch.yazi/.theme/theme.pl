# comment.line.number-sign
=begin
comment.block
=cut

my $num = 42;                       # constant.numeric
my $esc = "\n";                     # constant.character.escape
my $flag = 1;                       # constant.language

sub myFunction {                    # entity.name.function
    my ($param) = @_;               # variable.parameter
    my $color = "#ff0000";          # constant.other, string.quoted.double
    if ($flag) {                    # keyword.control
        return $color;              # keyword.control
    }
}
