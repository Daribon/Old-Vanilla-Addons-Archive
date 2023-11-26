#!/usr/bin/perl
#
# Generate RM tabs and players XML
#

if ($#ARGV != 1) {
  print "Usage: gentabs.pl num_tabs num_players_per_tab\n";
  exit(-1);
}

$num_tabs = $ARGV[0];
$num_players_per_tab = $ARGV[1];

$id = 1;

for ($t = 1; $t <= $num_tabs; $t++) {
  $lo = $id;
  $hi = $lo + $num_players_per_tab - 1;

  print <<EOF
  <!-- tab $t, player frames $lo-$hi -->
  <Button name="RaidMinionTab$t" parent="UIParent" inherits="RaidMinionTabTemplate" id="$t" hidden="true">
    <Anchors>
      <Anchor point="CENTER" relativePoint="CENTER"/>>
    </Anchors>
  </Button>

EOF
;

  for ($p = 1; $p <= $num_players_per_tab; $p++) {
    $lastid = $id - 1;
    if ($p == 1) {
      print <<EOF
  <Frame name="RaidMinionPlayer$id" parent="RaidMinionTab$t" inherits="RaidMinionPlayerButton" id="$id" hidden="true">
    <Anchors>
      <Anchor point="TOP" relativePoint="BOTTOM" relativeTo="RaidMinionTab$t"/>
    </Anchors>
  </Frame>
EOF
;
    } else {
      print <<EOF
  <Frame name="RaidMinionPlayer$id" parent="RaidMinionTab$t" inherits="RaidMinionPlayerButton" id="$id" hidden="true">
    <Anchors>
      <Anchor point="TOPLEFT" relativePoint="BOTTOMLEFT" relativeTo="RaidMinionPlayer$lastid"/>
    </Anchors>
  </Frame>
EOF
;
    }

    $id++;
  }

  print "\n";
}

