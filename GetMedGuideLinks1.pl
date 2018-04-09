#! c:\perl\bin

use warnings;
use MedGuideLink;
#use Logger;
use DateTime;
use File::Copy;

$Get = MedGuideLink->new("med_guide_link","ndc_code");
@Array = $Get->MedGuideLink();
$ctr  = 0;
$ctr1 = 0;
$ctr2 = 0;
$ctr3 = 0;
$ctr4 = 0;
$dt = DateTime->now;
$time = $dt->hms;



if (-e "MedGuideLinks.txt")
{
	print "EVER MAKE it HERE?\n";
	$Rfile = "MedGuideLinks".$time;
	$Rfile =~ s/\:/./g;
	print "$Rfile\n";
	move("c:\\temp\\MedGuideLinks.txt",$Rfile);
}
#MedGuideLinks.txt

open FILE, ">>", "MedGuideLinks.txt";

for $ndc (@Array)
{

	$GetD = MedGuideLink->new("med_guide_link","brand_description", $ndc);
	my @Array = $GetD->MedGuideLinkNDC();

		for $brand_description (@Array)
		{			


			$GetD = MedGuideLink->new("med_guide_link","med_guide_link", $ndc);
			my @Array = $GetD->MedGuideLinkNDC();

			for $med_guide_link (@Array)
			{
				
			if ($med_guide_link =~ m/medguide/)
			{


				use WWW::Mechanize;
				my $mech = WWW::Mechanize->new();

				for $url (@Array)
				{

    					$mech->get( $url );
 
					$STATUS = $mech->status();

				

					$content = $mech->content();

					if ($content)
					{

					
						if ($content =~ m/$brand_description/i)
						{

							$ctr = $ctr + 1;

							#open FILE, ">>", "MedGuideLinks.txt";
							print "$ndc|$brand_description|$url|$STATUS|MATCHBrandDescription|GREEN\n";
							print FILE "$ndc|$brand_description|$url|$STATUS|MATCHBrandDescription|GREEN\n";
							#close(FILE);
						}

						else
						{
							$ctr2 = $ctr2 + 1;
							print "$ndc|$brand_description|$url|$STATUS|NOMATCHBrandDescription|YELLOW\n";
							print FILE "$ndc|$brand_description|$url|$STATUS|NOMATCHBrandDescription|YELLOW\n";
							
								$GetD = MedGuideLink->new("med_guide_link","primary_description", $ndc);
								my @Array = $GetD->MedGuideLinkNDC();

								for $primary_description (@Array)
								{			


								$GetD = MedGuideLink->new("med_guide_link","med_guide_link", $ndc);
								my @Array = $GetD->MedGuideLinkNDC();

								for $med_guide_link (@Array)
								{
				
								if ($med_guide_link =~ m/medguide/)
								{

								use WWW::Mechanize;
								my $mech = WWW::Mechanize->new();

								for $url (@Array)
								{

    							$mech->get( $url );
 
								$STATUS = $mech->status();

								$content = $mech->content();

								if ($content)
								{
					
									if ($content =~ m/$primary_description/i)
									{

									$ctr = $ctr2 + 1;
									print "$ndc|$primary_description|$url|$STATUS|MATCHPrimaryDescription|ORANGE\n";
									print FILE "$ndc|$primary_description|$url|$STATUS|MATCHPrimaryDescription|ORANGE\n";
									}

									else
									{
									$ctr1 = $ctr3 + 1;
									print "$ndc|$primary_description|$url|$STATUS|NOMATCHPrimaryDescription|BLUE\n";
									print FILE "$ndc|$primary_description|$url|$STATUS|NOMATCHPrimaryDescription|BLUE\n";
									$primary_description_change = $primary_description;
									
										if ($primary_description_change =~ m/\-/)
										{
											$primary_description_change =~ s/\-/ /g;
										}

										if ($primary_description_change =~ m/\\/)
										{
											$primary_description_change =~ s/\\/ /g;
										}																			
										
										if ($primary_description_change =~ m/\//)
										{
											$primary_description_change =~ s/\// /g;
										}																				
										
										if ($primary_description_change =~ m/HCL/)
										{
											$primary_description_change =~ s/HLC//g;
										}
									
										if ($primary_description_change =~ m/hydrochloride/i)
										{
											$primary_description_change =~ s/hydrochloride//i;
										}
										
										@primary_description = split / /, $primary_description_change;
										
										for my $pd (@primary_description)
										{
											if ($content =~ m/$pd/i)
											{
												print "$ndc|$primary_description|$url|$STATUS|MATCHPrimaryDescription on $pd|BROWN\n";
												print FILE "$ndc|$primary_description|$url|$STATUS|MATCHPrimaryDescription on $pd|BROWN\n";
											}
											
											else
											{
												print "$ndc|$primary_description|$url|$STATUS|NOMATCHPrimaryDescription on $pd|RED\n";
												print FILE "$ndc|$primary_description|$url|$STATUS|NOMATCHPrimaryDescription on $pd|RED\n";
												$ctr4 = $ctr4 + 1;
											}
									
									}
									
									
									}
								}


								}
								}
								}
		
								}
							
							
						}
					}


				}
			}
			}
		
		}
}
print "Total Successful Loop counts:  $ctr\n";
print "Total Unsuccessful Loop counts: $ctr1\n";
print "Total Primary Description:  $ctr2\n";
print "Total Unsuccessful Primary Description:  $ctr3\n";
print "Total Failures:  $ctr4\n";
close(FILE);
exit;


