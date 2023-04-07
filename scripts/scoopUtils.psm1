function getHashFromUrl($url) {

    $wc = [System.Net.WebClient]::new();
    $FileHash = Get-FileHash -InputStream ($wc.OpenRead($url)) -Algorithm SHA256 ;
    $hash = $FileHash | Select-Object Hash ;
    $hash.Hash ;
}

function getLatestReleaseUrl([String]$user, [String]$repo) {
    "https://github.com/$user/$repo/releases/latest" ;
}

function getLatestCommitUrl([String]$user, [String]$repo) {
    $response = Invoke-WebRequest $(getLatestReleaseUrl $user $repo);
    $response.Links | Where-Object { $_.href -like "*commits*" } | ForEach-Object { $_.href } ;

}

function getLatestCommitTag([String]$user, [String]$repo) {
    $url = getLatestCommitUrl $user $repo ;
    $url -replace ".*commits\/" , "" ;
}

function getLatestReleaseZipUrl([String]$user, [String]$repo) {
    $tag = getLatestCommitTag $user $repo ;
    $url = "https://github.com/$user/$repo/archive/refs/tags/$tag.zip";
    $url ;
}

function getLatestReleasePageUrl([String]$user, [String]$repo) {
    $tag = getLatestCommitTag $user $repo ;
    $url = "https://github.com/$user/$repo/releases/tag/$tag" ;
    $url ;
}

function getLatestReleaseZipFile([String]$user, [String]$repo) {
    $tag = getLatestCommitTag $user $repo ;
    $download = "https://github.com/$user/$repo/archive/refs/tags/$tag.zip";
    $zip = "$tag.zip"

    Write-Host "Dowloading latest release from $user/$repo";
    Invoke-WebRequest $download -Out $zip ;

    $zip ;
}

function getHashLatestReleaseZipFile([String]$user, [String]$repo) {
    $tag = getLatestCommitTag $user $repo ;
    $zip = "$tag.zip"
    If (-not (Test-Path -Path $zip -PathType Leaf)) {
        $zip = getLatestReleaseZipFile $user $repo ;
        $hash = Get-FileHash $zip -Algorithm SHA256 ;
        Remove-Item $zip ;
        $hash.Hash ;
    }
    Else {
        $hash = Get-FileHash $zip -Algorithm SHA256 ;
        $hash.Hash ;
    }

}

# requires semver
# go install 

function checkSemverFile {
    if (-not (Test-Path .\.semver.yaml) ) {
        semver init ;
    }
}


function fmtTag($tagType) {
    $aliases = @{
        alpha = @('a', 'al','alpha', 'alhpa', 'lapha', 'alhap');
        beta = @('b', 'be', 'bet', 'beta', 'bta', 'btea', 'ebta', 'beat');
        release = @("r", "rel", "relea", "releas", "release", "erlease", "relaese", "erleaes", "releaes")
    } ;
    if ($aliases.alpha.Contains($tagType)) { return 'alpha'};
    if ($aliases.beta.Contains($tagType)) { return 'beta'};
    if ($aliases.release.Contains($tagType)) { return 'release'};
    else { return 'release' } ;
}

function incrementTag($tagType, $justPush = $false) {
    $tag = $tagType.Trim().ToLower();
    checkSemverFile ;
    $aliases = @{
        alpha = @('a', 'al','alpha', 'alhpa', 'lapha', 'alhap');
        beta = @('b', 'be', 'bet', 'beta', 'bta', 'btea', 'ebta', 'beat');
        release = @("r", "rel", "relea", "releas", "release", "erlease", "relaese", "erleaes", "releaes")
    } ;
    if (-not $aliases.Contains($tag) ) {
        Write-Host "⚠️ not a correct value: $tagType (try: alpha, beta, release)"
        Exit-PSSession -ErrorVariable $tagType;
    } elseif ($aliases.alpha.Contains($tag)) {
        if ($justPush) {
            git tag $(semver up alpha) ;
            Write-Host "✅ Created new alpha 📦 version: $(semver get alpha)" -ForegroundColor Green
        }
        git push -u origin master --tag $(semver get alpha);
        Write-Host "🔼📦 pushed: $(semver get alpha) to ☁️" -ForegroundColor Magenta;
    } elseif ($aliases.beta.Contains($tag)) {
        if ($justPush) {
            git tag $(semver up alpha) ;
            Write-Host "✅ Created new beta 📦 version: $(semver get beta)" -ForegroundColor Green
        }
        git push -u origin master --tag $(semver get beta);
        Write-Host "🔼📦 pushed: $(semver get beta) to ☁️" -ForegroundColor Magenta;
    } elseif ($aliases.release.Contains($tag)) {
        if ($justPush) {
            git tag $(semver up alpha) ;
            Write-Host "✅ Created new alpha 📦 version: $tag" -ForegroundColor Green
        }
        git push -u origin master --tag $(semver get release);
        Write-Host "🔼📦 pushed: $(semver get release) to ☁️" -ForegroundColor Magenta;
    } else {
        Write-Host "😕 Did not understand, try tags: alpha, beta, release";
    }
}

function releaseExtension($tagType = "alpha", $extType = ".exe", $justPush = $false) {

    $filesToRelease = Get-ChildItem -Recurse . -File -Name "*$extType" ;
    incrementTag -tagType $tagType -justPush $justPush ;

    $tag = fmtTag -tagType $(semver get $tagType) ;

    gh release create $tag -p --generate-notes;

    foreach( $file in $filesToRelease) {
        gh release upload $tag --clobber $file ;
    }

}

function exeRelease($tagType, $justPush = $false) {
    releaseExtension -tagType $tagType  -extType ".exe" -justPush $justPush;
}


