#!/bin/bash
echo "Patching superset in directory $2 with customizations from $1"

color_subt=("20a7c9/13294B" "1985a0/717f93" "d2edf4/cce9f6" "a5dbe9/99d3ec" "79cade/66bee3" "66bcfe/66bee3" "59c189/A9C13F"
            "1a85a0/13294B" "156378/717f93" "a5dae9/99d3ec" "444e7c/717f93" "363e63/42546f" "282e4a/13294B" "8e94b0/acacad"
            "b4b8ca/c7c7c8" "484848/747476" "666666/909091" "879399/c7c7c8" "a3a3a3/c7c7c8" "4d8cbe/66bee3" "315e7e/717f93"
            "b3defe/99d3ec" "5ac189/cbda8c" "439066/bacd65" "2b6144/A9C13F" "ace1c4/dde6b2" "fcc700/fdd133" "bc9501/FDC600"
            "7d6300/fdd133" "fde380/fee899" "737373/909091" "B2B2B2/e3e3e4" "FEC0A1/fee899" "0c5460/717f93" "20a7c933/fedd66"
            "666/acacad" "d1ecf1/cce9f6" "bee5eb/99d3ec" "E9F6F9/e3e3e4")

color_subt2=("#109618/#556120" "#316395/#42546f" "#329262/#5a6981" "#408184/#5a6981" "#546570/#5a6981" "#636363/#5d5d5e" "#637939/#657426" "#651067/#464647"
            "#969696/#909091" "#990099/#68686a" "#994499/#828284" "#005c66/#004968" "#007A87/#006692" "#0099c6/#0092d0" "#00a1b3/#0083bb" "#00b3a5/#0083bb"
            "#00d1c1/#1a9dd5" "#00ffeb/#33a8d9" "#03748E/#006692" "#17becf/#1a9dd5" "#1f77b4/#0083bb" "#1FA8C9/#1a9dd5" "#22aa99/#0083bb" "#29ABE2/#33a8d9"
            "#2ca02c/#657426" "#2D5584/#42546f" "#2f4554/#2b3e5d" "#3182bd/#1a9dd5" "#31a354/#5d5d5e" "#333D47/#3a3a3b" "#3366cc/#0083bb" "#33D9C1/#4db3de"
            "#393b79/#42546f" "#3b3eac/#42546f" "#3BA272/#5a6981" "#3CCCCB/#4db3de" "#454E7C/#42546f" "#484E5A/#515153" "#5254a3/#5a6981" "#5470C6/#717f93"
            "#5574a6/#717f93" "#55d12e/#879a32" "#5AC189/#717f93" "#61a0a8/#8994a5" "#6633cc/#5a6981" "#666666/#68686a" "#66aa00/#76872c" "#66CBE2/#66bee3"
            "#6b6ecf/#717f93" "#6baed6/#66bee3" "#6BD3B3/#66bee3" "#6C838E/#717f93" "#6e7074/#747476" "#73C0DE/#66bee3" "#749f83/#828284" "#74c476/#909091"
            "#7560AA/#717f93" "#756bb1/#717f93" "#7b0051/#464647" "#7b4173/#68686a" "#7f7f7f/#828284" "#81B9C6/#80c9e8" "#831C4A/#515153" "#843c39/#515153"
            "#8b0707/#654f00" "#8c564b/#68686a" "#8c6d31/#76872c" "#8ca252/#98ae39" "#8ce071/#bacd65" "#8FD3E4/#99d3ec" "#91c7ae/#a1a9b7" "#91CC75/#bacd65"
            "#9467bd/#8994a5" "#988b4e/#879a32" "#98df8a/#c3d479" "#9A60B4/#8994a5" "#9c9ede/#a1a9b7" "#9DACB9/#a1a9b7" "#9e9ac8/#a1a9b7" "#9ecae1/#99d3ec"
            "#9edae5/#99d3ec" "#9EE5E5/#99d3ec" "#9FC0C1/#a1a9b7" "#A1A6BD/#a1a9b7" "#a1d99b/#cbda8c" "#A38F79/#909091" "#A4A6AC/#acacad" "#a55194/#828284"
            "#A868B7/#8994a5" "#aaaa11/#b18b00" "#AC2077/#68686a" "#ACE1C4/#b8bfc9" "#ad494a/#68686a" "#aec7e8/#99d3ec" "#B17BAA/#9e9e9f" "#B2B2B2/#acacad"
            "#B2E5F0/#b3def1" "#b37e00/#b18b00" "#b4a76c/#bacd65" "#b5cf6b/#bacd65" "#B5E9D9/#b3def1" "#b82e2e/#7f6300" "#bbedab/#d4e09f" "#bcbd22/#a9c13f"
            "#bcbddc/#b8bfc9" "#bd9e39/#98ae39" "#bda29a/#acacad" "#bdbdbd/#bababb" "#c23531/#987700" "#c49c94/#acacad" "#c4ccd3/#c7c7c8" "#c5b0d5/#b8bfc9"
            "#c6dbef/#cce9f6" "#c7c7c7/#c7c7c8" "#c7e9c0/#dde6b2" "#C9BBAB/#bababb" "#ca8622/#ca9e00" "#cbc29a/#cbda8c" "#cc0086/#747476" "#ce6dbd/#acacad"
            "#cedb9c/#d4e09f" "#D1C6BC/#c7c7c8" "#D3B3DA/#c7c7c8" "#d48265/#b2c752" "#d62728/#987700" "#d6616b/#909091" "#D9BDD5/#d5d5d6" "#d9d9d9/#d5d5d6"
            "#dadaeb/#e3e3e4" "#dbdb8d/#cbda8c" "#dc3912/#987700" "#dd4477/#828284" "#de9ed6/#c7c7c8" "#E04355/#b18b00" "#e377c2/#bababb" "#E4DDD5/#e3e3e4"
            "#e6550d/#b18b00" "#e67300/#ca9e00" "#e7969c/#acacad" "#e7ba52/#fed74d" "#e7cb94/#d4e09f" "#EA0B8C/#828284" "#EA7CCC/#bababb" "#EE5960/#909091"
            "#EE6666/#909091" "#EFA1AA/#bababb" "#F6ACAF/#c7c7c8" "#f7b6d2/#d5d5d6" "#FAC858/#fed74d" "#FC8452/#fdd133" "#FCC550/#fed74d" "#FCC700/#fdc600"
            "#fd8d3c/#fdd133" "#fdae6b/#fedd66" "#fdd0a2/#fee899" "#FDE2A7/#fee899" "#FDE380/#fee380" "#FEC0A1/#fee899" "#ff1ab1/#9e9e9f" "#ff3339/#b18b00"
            "#ff5a5f/#fed74d" "#ff7f0e/#e4b200" "#FF7F44/#fdd133" "#ff8083/#fedd66" "#FF874E/#fdd133" "#ff9896/#fee380" "#ff9900/#e4b200" "#ffb400/#fdc600"
            "#ffbb78/#fedd66" "#FFC3A6/#fee899" "#ffd266/#fedd66" "#EBF5F8/#e6f4fa" "#6BB1CC/#66bee3" "#357E9B/#5a6981" "#1B4150/#2b3e5d" "#092935/#0f213c"
            "#E70B81/#747476" "#FAFAFA/#ffffff" "#ffffcc/#fff4cc" "#78c679/#909091" "#006837/#003a53" "#f2f0f7/#f1f1f1" "#54278f/#42546f" "#fef0d9/#fff4cc"
            "#fc8d59/#fed74d" "#b30000/#654f00" "#d7191c/#987700" "#fdae61/#fed74d" "#ffffbf/#fff4cc" "#abd9e9/#b3def1" "#2c7bb6/#0083bb" "#a6611a/#987700"
            "#dfc27d/#c3d479" "#f5f5f5/#f1f1f1" "#80cdc1/#80c9e8" "#018571/#006692" "#7b3294/#5a6981" "#c2a5cf/#b8bfc9" "#f7f7f7/#f1f1f1" "#a6dba0/#cbda8c"
            "#008837/#004968" "#F4FAD4/#eef3d9" "#D7F1AC/#dde6b2" "#A9E3AF/#bababb" "#82CDBB/#80c9e8" "#63C1BF/#66bee3" "#2367AC/#0075a6" "#2A2D84/#2b3e5d"
            "#251354/#13294b" "#050415/#04080f" "#FBF1B4/#feeeb3" "#FDD093/#fee899" "#FEAD71/#fedd66" "#C53D6F/#747476" "#952B7B/#68686a" "#4F167B/#2b3e5d"
            "#E87180/#9e9e9f" "#F7D0D4/#e3e3e4" "#F6F6F7/#f1f1f1" "#C8E9F1/#cce9f6" "#58BDD7/#4db3de" "#FF9E72/#fedd66" "#FFDFD0/#fff4cc" "#F3FAEB/#f6f9ec"
            "#DEF2D7/#eef3d9" "#CAEAC4/#dde6b2" "#98DEBC/#b8bfc9" "#69D3B5/#66bee3" "#4AA59D/#717f93" "#287886/#006692" "#0D5B6A/#004968" "#03273F/#002c3e"
            "#FEECE8/#fff9e6" "#FDE2DA/#eef3d9" "#FCCEC2/#feeeb3" "#F998AA/#bababb" "#F76896/#acacad" "#D13186/#828284" "#AC0378/#5d5d5e" "#790071/#515153"
            "#43026C/#2b3e5d" "#C59DC0/#bababb" "#CBEFE5/#cce9f6" "#98DECA/#99d3ec" "#64D0B0/#66bee3" "#CB5171/#828284" "#D87C94/#9e9e9f" "#E5A8B7/#c7c7c8"
            "#F2D3DB/#e3e3e4" "#CEE8EC/#cce9f6" "#9CD1D8/#99d3ec" "#6CBAC6/#66bee3" "#3AA3B2/#33a8d9" "#67001f/#4c3b00" "#b2182b/#7f6300" "#d6604d/#b18b00"
            "#f4a582/#fee380" "#fddbc7/#fff4cc" "#d1e5f0/#cce9f6" "#92c5de/#80c9e8" "#4393c3/#33a8d9" "#2166ac/#0075a6" "#053061/#003a53" "#543005/#4c3b00"
            "#8c510a/#7f6300" "#bf812d/#b18b00" "#f6e8c3/#fff4cc" "#c7eae5/#cce9f6" "#35978f/#5a6981" "#01665e/#004968" "#003c30/#002c3e" "#40004b/#2e2e2f"
            "#762a83/#5d5d5e" "#9970ab/#8994a5" "#e7d4e8/#e3e3e4" "#d9f0d3/#e5ecc5" "#5aae61/#747476" "#1b7837/#556120" "#00441b/#001d2a" "#8e0152/#464647"
            "#c51b7d/#747476" "#de77ae/#acacad" "#f1b6da/#d5d5d6" "#fde0ef/#f1f1f1" "#e6f5d0/#eef3d9" "#b8e186/#cbda8c" "#7fbc41/#98ae39" "#4d9221/#657426"
            "#276419/#444d19" "#2d004b/#112544" "#542788/#42546f" "#8073ac/#717f93" "#b2abd2/#b8bfc9" "#d8daeb/#e3e3e4" "#fee0b6/#feeeb3" "#fdb863/#fedd66"
            "#e08214/#ca9e00" "#b35806/#987700" "#7f3b08/#654f00" "#e0e0e0/#e3e3e4" "#bababa/#bababb" "#878787/#828284" "#4d4d4d/#515153" "#1a1a1a/#171718"
            "#a50026/#654f00" "#d73027/#987700" "#f46d43/#ca9e00" "#fee090/#fee899" "#e0f3f8/#e6f4fa" "#74add1/#66bee3" "#4575b4/#717f93" "#313695/#42546f"
            "#fee08b/#fee380" "#d9ef8b/#cbda8c" "#a6d96a/#bacd65" "#66bd63/#98ae39" "#1a9850/#00587d" "#9e0142/#464647" "#d53e4f/#987700" "#e6f598/#fee899"
            "#abdda4/#cbda8c" "#66c2a5/#8994a5" "#3288bd/#1a9dd5" "#5e4fa2/#5a6981" "#b5d4e9/#b3def1" "#93c3df/#99d3ec" "#6daed5/#66bee3" "#4b97c9/#33a8d9"
            "#2f7ebc/#1a9dd5" "#1864aa/#0075a6" "#0a4a90/#00587d" "#08306b/#004968" "#b7e2b1/#d4e09f" "#97d494/#c3d479" "#73c378/#909091" "#4daf62/#747476"
            "#2f984f/#5d5d5e" "#157f3b/#004968" "#036429/#003a53" "#cecece/#c7c7c8" "#b4b4b4/#bababb" "#979797/#909091" "#7a7a7a/#747476" "#5f5f5f/#5d5d5e"
            "#404040/#3a3a3b" "#1e1e1e/#232323" "#000000/#000000" "#fdc28c/#fee380" "#fda762/#fed74d" "#fb8d3d/#fdd133" "#f2701d/#ca9e00" "#e25609/#b18b00"
            "#c44103/#987700" "#9f3303/#7f6300" "#7f2704/#654f00" "#cecee5/#d0d4db" "#b6b5d8/#b8bfc9" "#9e9bc9/#a1a9b7" "#8782bc/#8994a5" "#7363ac/#717f93"
            "#61409b/#5a6981" "#501f8c/#42546f" "#3f007d/#2b3e5d" "#fcaa8e/#fee380" "#fc8a6b/#fed74d" "#f9694c/#ca9e00" "#ef4533/#b18b00" "#d92723/#987700"
            "#bb151a/#7f6300" "#970b13/#654f00" "#67000d/#4c3b00" "#482475/#2b3e5d" "#414487/#42546f" "#355f8d/#42546f" "#2a788e/#006692" "#21918c/#0075a6"
            "#22a884/#0075a6" "#44bf70/#717f93" "#7ad151/#98ae39" "#bddf26/#a9c13f" "#fde725/#fdd133" "#160b39/#0d1d35" "#420a68/#2b3e5d" "#6a176e/#515153"
            "#932667/#5d5d5e" "#bc3754/#68686a" "#dd513a/#b18b00" "#f37819/#ca9e00" "#fca50a/#e4b200" "#f6d746/#fed74d" "#fcffa4/#feeeb3" "#140e36/#0d1d35"
            "#3b0f70/#2b3e5d" "#641a80/#42546f" "#8c2981/#68686a" "#b73779/#747476" "#de4968/#828284" "#f7705c/#fed74d" "#fe9f6d/#fedd66" "#fecf92/#fee899"
            "#fcfdbf/#fff4cc" "#963db3/#717f93" "#bf3caf/#909091" "#e4419d/#909091" "#fe4b83/#9e9e9f" "#ff5e63/#fed74d" "#ff7847/#fdd133" "#fb9633/#fdd133"
            "#e2b72f/#fdd133" "#c6d63c/#b2c752" "#aff05b/#bacd65" "#6054c8/#717f93" "#4c6edb/#33a8d9" "#368ce1/#33a8d9" "#23abd8/#33a8d9" "#1ac7c2/#33a8d9"
            "#1ddfa3/#33a8d9" "#30ef82/#33a8d9" "#52f667/#b2c752" "#7ff658/#b2c752" "#1a1530/#0b192d" "#163d4e/#13294b" "#1f6642/#2b3e5d" "#54792f/#657426"
            "#a07949/#879a32" "#d07e93/#9e9e9f" "#cf9cda/#b8bfc9" "#c1caf3/#b3def1" "#d2eeef/#cce9f6" "#ffffff/#ffffff" "#b7e4da/#b3def1" "#8fd3c1/#80c9e8"
            "#68c2a3/#8994a5" "#49b17f/#717f93" "#2f9959/#42546f" "#157f3c/#004968" "#b2cae1/#b3def1" "#9cb3d5/#a1a9b7" "#8f95c6/#a1a9b7" "#8c74b5/#8994a5"
            "#8952a5/#717f93" "#852d8f/#5a6981" "#730f71/#515153" "#4d004b/#2e2e2f" "#bde5bf/#c7c7c8" "#9ed9bb/#b8bfc9" "#7bcbc4/#80c9e8" "#58b7cd/#4db3de"
            "#399cc6/#33a8d9" "#1d7eb7/#0083bb" "#0b60a1/#006692" "#084081/#00587d" "#fdca94/#fee899" "#fdb07a/#fedd66" "#fa8e5d/#fed74d" "#f16c49/#ca9e00"
            "#e04530/#b18b00" "#c81d13/#7f6300" "#a70403/#654f00" "#7f0000/#4c3b00" "#bec9e2/#d0d4db" "#98b9d9/#99d3ec" "#69a8cf/#66bee3" "#4096c0/#33a8d9"
            "#19879f/#0075a6" "#037877/#006692" "#016353/#004968" "#014636/#002c3e" "#bfc9e2/#d0d4db" "#9bb9d9/#99d3ec" "#72a8cf/#66bee3" "#4394c3/#33a8d9"
            "#1a7db6/#0083bb" "#0667a1/#0075a6" "#045281/#00587d" "#023858/#003a53" "#d0aad2/#c7c7c8" "#d08ac2/#bababb" "#dd63ae/#9e9e9f" "#e33890/#909091"
            "#d71c6c/#747476" "#b70b4f/#5d5d5e" "#8f023a/#464647" "#fbb5bc/#d5d5d6" "#f993b0/#bababb" "#f369a3/#acacad" "#e03e98/#909091" "#c01788/#747476"
            "#99037c/#5d5d5e" "#700174/#515153" "#49006a/#2b3e5d" "#d5eeb3/#dde6b2" "#a9ddb7/#b8bfc9" "#73c9bd/#66bee3" "#45b4c2/#4db3de" "#2897bf/#1a9dd5"
            "#2073b2/#0075a6" "#234ea0/#006692" "#1c3185/#2b3e5d" "#081d58/#13294b" "#e4f4ac/#dde6b2" "#c7e89b/#d4e09f" "#a2d88a/#c3d479" "#78c578/#909091"
            "#4eaf63/#747476" "#2f944e/#5d5d5e" "#15793f/#004968" "#036034/#003a53" "#004529/#002c3e" "#feeaa1/#fee899" "#fed676/#fee380" "#feba4a/#fed74d"
            "#fb992c/#fdcc1a" "#ee7918/#ca9e00" "#d85b0a/#b18b00" "#b74304/#987700" "#8f3204/#654f00" "#662506/#4c3b00" "#fee087/#fee380" "#fec965/#fedd66"
            "#feab4b/#fed74d" "#fd893c/#fdd133" "#fa5c2e/#ca9e00" "#ec3023/#b18b00" "#d31121/#7f6300" "#af0225/#654f00" "#800026/#4c3b00" "#5ac19e/#8994a5"
            "#1f86c9/#1a9dd5" "#47457c/#42546f" "#e05043/#b18b00" "#ffa444/#fdd133" "#FF69B4/#bababb" "#ADD8E6/#b3def1")


#superset_dir="$HOME/Desktop/IT_data/Apache_Superset"


sed -i.bak 's/bool(appbuilder.app.config\["LOGO_TARGET_PATH"\])/False/' $superset_dir/superset/initialization/__init__.py

# Changing logo size and padding
find $superset_dir/superset-frontend/packages/superset-ui-core/src -type f -name 'index.tsx' -execdir sed -i.bak "s/37,/60,/gI" {} +
find $superset_dir/superset-frontend -type f -name 'Menu.tsx' -execdir sed -i.bak "s/theme.brandIconMaxWidth}px;/60}px;/gI" {} +
find $superset_dir/superset-frontend -type f -name 'Menu.tsx' -execdir sed -i.bak "s/2}px/6}px/gI" {} +

# Changing dashboard colors
sed -i.bak 's/{"r": 0, "g": 122, "b": 135, "a": 1}/{"r": 169, "g": 193, "b": 63, "a": 1}/gI' "$superset_dir/superset/examples/deck.py"
find "$superset_dir/superset-frontend" -type f -name 'controls.jsx' -execdir sed -i.bak 's/{ r: 0, g: 122, b: 135, a: 1 }/{ r: 169, g: 193, b: 63, a: 1 }/gI' {} +

# Changing HEX colors in below files to modify the UI
for val in ${color_subt[*]}; do
    sed -i.bak "s/$val/gI" $superset_dir/docs/src/styles/antd-theme.less
    sed -i.bak "s/$val/gI" $superset_dir/docs/src/styles/custom.css
    sed -i.bak "s/$val/gI" $superset_dir/superset-frontend/src/assets/stylesheets/antd/index.less
    sed -i.bak "s/$val/gI" $superset_dir/docs/src/pages/index.tsx
    sed -i.bak "s/$val/gI" $superset_dir/superset-frontend/packages/superset-ui-core/src/style/index.tsx
    sed -i.bak "s/$val/gI" $superset_dir/superset-frontend/src/assets/stylesheets/less/variables.less;
done

for val in ${color_subt2[*]}; do
    sed -i.bak "s/$val/gI" $superset_dir/superset-frontend/packages/superset-ui-core/src/color/colorSchemes/categorical/*.ts
    sed -i.bak "s/$val/gI" $superset_dir/superset-frontend/packages/superset-ui-core/src/color/colorSchemes/sequential/*.ts
    find $superset_dir/superset/examples/ -type f -name '*.yaml' -execdir sed -i.bak "s/$val/gI" {} +
    find $superset_dir/superset-frontend/src/explore/controlUtils -type f -name '*.ts' -execdir sed -i.bak "s/$val/gI" {} +
    find $superset_dir/superset-frontend/src/dashboard/components -type f -name '*.tsx' -execdir sed -i.bak "s/$val/gI" {} +
    sed -i.bak "s/$val/gI" $superset_dir/superset/examples/*.py
    sed -i.bak "s/$val/gI" $superset_dir/superset-frontend/spec/fixtures/mockDashboardState.js;
done

echo "Creating and populating 'custom_assets' directory in Superset..."
mkdir "$superset_dir/custom_assets"
cp ${base_dir}/files/*.svg "$superset_dir/superset-frontend/src/assets/images/"










line_number=$(grep -n "from superset.tags.api import TagRestApi" $superset_dir/superset/initialization/__init__.py | cut -d: -f1)
sed -i "${line_number}a\        from superset.views.reporting_service import ReportingServiceView\n        from superset.views.blob_storage import BlobStorageLinkGeneratorView" $superset_dir/superset/initialization/__init__.py

line_number=$(grep -n "appbuilder.add_view_no_menu(Api)" $superset_dir/superset/initialization/__init__.py | cut -d: -f1)
sed -i "${line_number}a\        appbuilder.add_view_no_menu(ReportingServiceView)\n        appbuilder.add_view_no_menu(BlobStorageLinkGeneratorView)" $superset_dir/superset/initialization/__init__.py


#echo "Copying Python files to '$superset_dir/superset/custom_assets/"
#mkdir -p "$superset_dir/superset/custom_assets"
#cp ${base_dir}/files/custom_auth_oauth_view.py "$superset_dir/superset/custom_assets/"
#cp ${base_dir}/files/custom_sso_security_manager.py "$superset_dir/superset/custom_assets/"




echo "Copying custom views '$superset_dir/superset/views/"
cp "${base_dir}/files/reporting_service.py" "$superset_dir/superset/views/"
cp "${base_dir}/files/blob_storage.py" "$superset_dir/superset/views/"

echo "Copying setupFormatters.ts file to 'superset/superset-frontend/src/setup/'..."
cp ${base_dir}/files/setupFormatters.ts "$superset_dir/superset-frontend/src/setup/"

echo "Copying HandlebarsViewer.tsx file to 'superset/superset-frontend/plugins/plugin-chart-handlebars/'..."
cp ${base_dir}/files/HandlebarsViewer.tsx "$superset_dir/superset-frontend/plugins/plugin-chart-handlebars/src/components/Handlebars/"

echo "Patch requirements"
cat ${base_dir}/files/python_requirements.txt >> $superset_dir/requirements/base.txt
