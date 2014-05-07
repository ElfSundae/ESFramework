#appledoc Xcode script
outputPath="${SRCROOT}/../docs/docset";
/usr/local/bin/appledoc \
--project-name "${PROJECT_NAME}" \
--project-company "www.0x123.com" \
--company-id "com.0x123" \
--docset-atom-filename "${PROJECT_NAME}.atom" \
--docset-feed-url "https://raw.githubusercontent.com/ElfSundae/ESFramework/master/docs/docset/publish/%DOCSETATOMFILENAME" \
--docset-package-url "https://raw.githubusercontent.com/ElfSundae/ESFramework/master/docs/docset/publish/%DOCSETPACKAGEFILENAME" \
--docset-fallback-url "http://www.0x123.com" \
--output "${outputPath}" \
--publish-docset \
--docset-platform-family "iphoneos" \
--logformat xcode \
--use-code-order \
--keep-intermediate-files \
--keep-undocumented-objects \
--keep-undocumented-members \
--no-warn-undocumented-object \
--no-warn-undocumented-member \
--no-warn-empty-description \
--warn-unknown-directive \
--warn-invalid-crossref \
--no-repeat-first-par \
--exit-threshold 2 \
--ignore .m \
--ignore Vendor \
--ignore _Internal \
--index-desc "${outputPath}/README.md" \
"${PROJECT_DIR}"