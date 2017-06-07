-module(erljwt_test).
-include_lib("eunit/include/eunit.hrl").

-define(RSA_PUBLIC_KEY,{'RSAPublicKey', 26764034142824704671470727133910664843434961952272064166426226039805773031712563508339384620585192869091085197093344386232207542619708787421377966896296841271368128705832667137731759368836398793992412062213039259549646668413294499661784015754202306959856976300366659103241590400757099670805804654764282426982148086034348017908262389651476327142185608358813461989019448157613779262598416478574844583047253739496922447827706849259886451307152776609476861777213322863455948194927465841543344937499194416674011076061250124513400818349182398008202094247204740240584520318269147256825860139612842332966614539793342302993867, 65537}).

-define(RSA_PRIVATE_KEY,{'RSAPrivateKey','two-prime',
                     26764034142824704671470727133910664843434961952272064166426226039805773031712563508339384620585192869091085197093344386232207542619708787421377966896296841271368128705832667137731759368836398793992412062213039259549646668413294499661784015754202306959856976300366659103241590400757099670805804654764282426982148086034348017908262389651476327142185608358813461989019448157613779262598416478574844583047253739496922447827706849259886451307152776609476861777213322863455948194927465841543344937499194416674011076061250124513400818349182398008202094247204740240584520318269147256825860139612842332966614539793342302993867,
                     65537,
                     12794561693313670100205653006781224797363586340001583385478945661643268216176428806876618096082122962427692741885262975428461209855127276346365743059050308024962440641984489088989975449374313353003376259351732914257448923835215476363026888834996387949590598707455138772060958348043394306824326103327356583873848688304161573971837684253713093328415056019518486753353685104889273063916897235433180509399999298673446273215515841603080826297295537431001587831668670650206107678796371102894820869947413565783400511327660856890784768064128415588379491565702377411884622967328023716684228979596814867941892555080877039934913,
                     175921812047663448018479509235149059234162469604896431741565550421215807198867689136961832929735756392012649052466171066035877581304404480112067613119039884401516991962137582818872105841975489123820547558891955007907269296649095288060806030752931271323412548318651305799213788576544135388323426837173991918523,
                     152135962171497984267966543913856108347630812566910071974963337510843417419284055362416709755317088206676526904022621662056506919405421710738842624864481880983646685082220280096388715674338529824473346539992718562264652001183670660912857359719070110573506895077317198382716742487416742094479674005148886682929,
                     7940197446282076983057851111853928577973550591136055130560613060499509554820187443232572467555096623397064496348550193224195887597821512308642385211500678670974979968933624822287008698606336830008410206130924560376424044119932616111263320551248465760938924850490113410044316746409166615479205587444659781421,
                     84323951750609034263605058328437724273733757518546902734188980805978106073752129499973861816407422205891707581802977430675841339203838192816095615426435514697513859890011011710962053448744176509055866351301333624887673893266350866802867747864492145911204937114661141511698516423629600936600304533882132364273,
                     146498358518282536624753849370270691372323087909948725666061752883743908775492534384951112165832037025133690750650675527600809535328134914630670173454194925358833883485231412349407499865536427735554260391108738360645045140719276539512627330123338501657698608899096243687786198062042440767530650052735017635902,
                     asn1_NOVALUE}).

rs256_verification_test() ->
    IdToken =
    <<"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE0NjA2MzE4MjEsImlzcyI6Imh0dHBzOi8vcHJvdG9uLnNjYy5raXQuZWR1Iiwic3ViIjoiam9lIiwiYXVkIjoiMTIzIiwiaWF0IjoxNDYwNjMxNTIxLCJhdXRoX3RpbWUiOjE0NjA2MzE1MjF9.nUKMCw_ppksTD49qWR7hs_FTNnVu2qaohnh67jANI9Cje7gaFi2puIsXbC_i0HoFnppR5mA_3B20f7X8O3UF3ZrgYyfjjAq5U3HeZ-Tx6xEd2EcJ-gfpVnoAJPa46Lx77NmApUyTAazXj8kjzgkh58_QDxujG13g55ckRG9qJfK3bX_h0ec07ARJWQSg_Zh8Q3lFB_iIbSDXOYegSAHhIpTxmuTA-qmPn3ySGIRirQt_-niek0-wyy5PAsxSU9lc42QIG7qdMLhvXsq5j52kPO9DA3vJNpGTloJ8H1AoE-ES8HpXH3RhRMe3cdiVyK2vTsPbRc0-GxkRZMKaocyOPQ">>,
    expired = erljwt:parse(IdToken,?RSA_PUBLIC_KEY),
    ok.


none_roundtrip_test() ->
    application:set_env(erljwt, add_iat, false),
    Claims = claims(),
    JWT = erljwt:create(none, Claims, 10, undefined),
    Result = erljwt:parse(JWT,undefined),
    true = valid_claims(Claims, Result).

hs256_roundtrip_test() ->
    application:set_env(erljwt, add_iat, false),
    Claims = claims(),
    Key = <<"my secret key">>,
    JWT = erljwt:create(hs256,Claims, 10, Key),
    Result = erljwt:parse(JWT,Key),
    true = valid_claims(Claims, Result).

rsa256_roundtrip_test() ->
    application:set_env(erljwt, add_iat, false),
    Claims = claims(),
    JWT = erljwt:create(rs256, Claims, 10, ?RSA_PRIVATE_KEY),
    Result = erljwt:parse(JWT,?RSA_PUBLIC_KEY),
    true = valid_claims(Claims, Result).


unsupported_alg_test() ->
    application:set_env(erljwt, add_iat, false),
    Claims = claims(),
    Key = <<"my secret key">>,
    alg_not_supported = erljwt:create(xy21,Claims, 10, Key),
    application:unset_env(erljwt, add_iat).

to_map_test() ->
    Claims = claims(),
    JWT = erljwt:create(none, Claims, 10, undefined),
    Result = erljwt:to_map(JWT),
    Result = erljwt:parse(JWT,undefined),
    true = valid_claims(Claims, Result).

exp_test() ->
    application:set_env(erljwt, add_iat, true),
    Claims = claims(),
    JWT = erljwt:create(rs256, Claims, ?RSA_PRIVATE_KEY),
    Result = erljwt:parse(JWT,?RSA_PUBLIC_KEY),
    true = valid_claims(Claims, Result).

exp_fail_test() ->
    application:set_env(erljwt, add_iat, true),
    Now = erlang:system_time(seconds),
    Claims = maps:merge(#{exp=> (Now -1)}, claims()),
    JWT = erljwt:create(rs256, Claims, ?RSA_PRIVATE_KEY),
    expired = erljwt:parse(JWT,?RSA_PUBLIC_KEY).

iat_fail_test() ->
    application:set_env(erljwt, add_iat, true),
    Now = erlang:system_time(seconds),
    Claims = maps:merge(#{iat => (Now + 10)}, claims()),
    JWT = erljwt:create(rs256, Claims, 10, ?RSA_PRIVATE_KEY),
    not_issued_in_past = erljwt:parse(JWT,?RSA_PUBLIC_KEY).

iat_test() ->
    application:set_env(erljwt, add_iat, true),
    Claims = claims(),
    JWT = erljwt:create(rs256, Claims, 10, ?RSA_PRIVATE_KEY),
    timer:sleep(2000),
    Result = erljwt:parse(JWT,?RSA_PUBLIC_KEY),
    true = valid_claims(Claims, Result).

nbf_fail_test() ->
    application:set_env(erljwt, add_iat, true),
    Now = erlang:system_time(seconds),
    Claims = maps:merge(#{nbf => (Now + 1)}, claims()),
    JWT = erljwt:create(rs256, Claims, 10, ?RSA_PRIVATE_KEY),
    not_yet_valid = erljwt:parse(JWT,?RSA_PUBLIC_KEY).

nbf_test() ->
    application:set_env(erljwt, add_iat, true),
    Now = erlang:system_time(seconds),
    Claims = maps:merge(#{nbf => (Now + 1)}, claims()),
    JWT = erljwt:create(rs256, Claims, 10, ?RSA_PRIVATE_KEY),
    timer:sleep(2000),
    Result = erljwt:parse(JWT,?RSA_PUBLIC_KEY),
    true = valid_claims(Claims, Result).

valid_claims(OrgClaims, #{claims := ExtClaims}) when is_map(ExtClaims) ->
    io:format("org claims: ~p~n~next claims: ~p~n~n", [OrgClaims, ExtClaims]),
    io:format("add iat ~p~n",[add_iat()]),
    IatOk = (add_iat() == maps:is_key(iat, ExtClaims)),
    SameClaims =
        (ExtClaims == maps:merge(OrgClaims, maps:with([exp, iat], ExtClaims))),
    application:unset_env(erljwt, add_iat),
    io:format("iat ok: ~p, same claims: ~p~n", [IatOk, SameClaims]),
    IatOk and SameClaims;
valid_claims(_OrgClaims, _)  ->
    io:format("no maps"),
    application:unset_env(erljwt, add_iat),
    false.

algo_test() ->
    application:set_env(erljwt, add_iat, false),
    Claims = claims(),
    JWT = erljwt:create(rs256, Claims, 10, ?RSA_PRIVATE_KEY),
    Result = erljwt:parse(JWT, [rs256], ?RSA_PUBLIC_KEY),
    true = valid_claims(Claims, Result).

algo_fail_test() ->
    application:set_env(erljwt, add_iat, false),
    Claims = claims(),
    Key = <<"my secret key">>,
    JWT = erljwt:create(hs256,Claims, 10, Key),
    algo_not_allowed = erljwt:parse(JWT, [rs256], ?RSA_PUBLIC_KEY).

garbage_test() ->
    %% JWT = erljwt:create(rs256, claims(), 10, ?RSA_PRIVATE_KEY),
    invalid = erljwt:parse(<<"abc">>, #{keys => []}),
    ok.

claims() ->
    #{iss => <<"me">>,
      sub => <<"789049">>,
      <<"aud">> => <<"someone">>,
      <<"azp">> => <<"thesameone">>,
      <<"nonce">> => <<"WwiTGOVNCSTn6tXFp8iW_wsugAp1AGm-81VJ9n4oy7Bauq0xTKg">>}.

add_iat() ->
    application:get_env(erljwt, add_iat, true).
