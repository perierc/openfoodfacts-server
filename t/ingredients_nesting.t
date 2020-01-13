#!/usr/bin/perl -w

use strict;
use warnings;

use utf8;

use Test::More;
use Log::Any::Adapter 'TAP';

use ProductOpener::Tags qw/:all/;
use ProductOpener::TagsEntries qw/:all/;
use ProductOpener::Ingredients qw/:all/;

# dummy product for testing

my @tests = (
	[ { lc => "en", ingredients_text => "sugar and water"}, 
[
  {
    'id' => 'en:sugar',
    'rank' => 1,
    'text' => 'sugar',
    'vegan' => 'yes',
    'vegetarian' => 'yes'
  },
  {
    'id' => 'en:water',
    'rank' => 2,
    'text' => 'water',
    'vegan' => 'yes',
    'vegetarian' => 'yes'
  }
]
	],

	[ { lc => "en", ingredients_text => "chocolate (cocoa, sugar), milk"}, 
[
  {
    'has_sub_ingredients' => 'yes',
    'id' => 'en:chocolate',
    'ingredients' => [
      {
        'id' => 'en:cocoa',
        'text' => 'cocoa'
      },
      {
        'id' => 'en:sugar',
        'text' => 'sugar'
      }
    ],
    'rank' => 1,
    'text' => 'chocolate',
    'vegan' => 'maybe',
    'vegetarian' => 'yes'
  },
  {
    'id' => 'en:milk',
    'rank' => 2,
    'text' => 'milk',
    'vegan' => 'no',
    'vegetarian' => 'yes'
  },
  {
    'id' => 'en:cocoa',
    'text' => 'cocoa',
    'vegan' => 'yes',
    'vegetarian' => 'yes'
  },
  {
    'id' => 'en:sugar',
    'text' => 'sugar',
    'vegan' => 'yes',
    'vegetarian' => 'yes'
  }
]

	],
	[ { lc => "en", ingredients_text => "dough (wheat, water, raising agents: E501, salt), chocolate (cocoa (cocoa butter, cocoa paste), sugar), milk"}, 
	[]
	],
);

foreach my $test_ref (@tests) {

	my $product_ref = $test_ref->[0];
	my $expected_ingredients_ref = $test_ref->[1];

	print STDERR "ingredients_text: " . $product_ref->{ingredients_text} . "\n";

	extract_ingredients_from_text($product_ref);

	is_deeply ($product_ref->{ingredients}, $expected_ingredients_ref)
		# using print + join instead of diag so that we don't have
		# hashtags. It makes copy/pasting the resulting structure
		# inside the test file much easier when tests results need
		# to be updated. Caveat is that it might interfere with
		# test output.
		or print STDERR join("\n", explain $product_ref->{ingredients});
}

done_testing();
