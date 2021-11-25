\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{waku}[2021/11/19]

\newif\iflandscape\landscapefalse
\DeclareOption{landscape}{\landscapetrue}
\ProcessOptions\relax
\newif\ifgrid\gridfalse
\DeclareOption{grid}{\gridtrue}
\ProcessOptions\relax

\iflandscape
	\LoadClass[
		jafontsize=2.5mm,
		baselineskip=1.1zh,
		line_length=88mm,
		cmyk,
		paper={88mm,63mm},
		gutter=0pt,
		head_space=0pt,
		foot_space=0pt,
		fore-edge=0pt,
		open_bracket_pos=nibu_tentsuki,
		hanging_punctuation,
	]{jlreq}
\else
	\LoadClass[
		jafontsize=2.5mm,
		baselineskip=1.1zh,
		line_length=63mm,
		cmyk,
		paper={63mm,88mm},
		gutter=0pt,
		head_space=0pt,
		foot_space=0pt,
		fore-edge=0pt,
		open_bracket_pos=nibu_tentsuki,
		hanging_punctuation,
	]{jlreq}
\fi

\RequirePackage[dvipsnames]{xcolor}

\RequirePackage{luatexja,xparse,fontspec,bxokumacro,bxghost,ifthen,xkeyval}
\RequirePackage{amsmath}
\ltjsetparameter{jacharrange={-3,-8}}
\RequirePackage[no-math,match,deluxe]{luatexja-preset}
\RequirePackage[x-1a]{pdfx}

\RequirePackage[pdfbox]{gentombow}
\settombowbleed{3mm}

\RequirePackage{tikz}
\usetikzlibrary{calc,fadings,patterns,arrows.meta,shapes.symbols}
\setlength{\parskip}{0pt}
\RequirePackage[export]{adjustbox}

\RequirePackage{luacode}
%% \PUACHAR{«num»}
% コードポイントが num である文字を出力する
\begin{luacode*}
	my = my or {}
	function my.pua(n)
		local t, c = font.getfont(font.current()), 0
		if t and t.shared and t.shared.rawdata and t.shared.rawdata.descriptions then
			for i,v in pairs(t.shared.rawdata.descriptions) do
				if not v.name and v.unicode==n then c=i; break end
			end
		end
		tex.sprint(tostring(c))
	end
\end{luacode*}
\def\PUACHAR#1{\char\directlua{my.pua(\the\numexpr#1)}}

\defaultjfontfeatures{
	Ligatures=TeX,
	YokoFeatures={JFM=jlreq},   % jlreqのJFMを維持する
	TateFeatures={JFM=jlreqv},  % https://qiita.com/zr_tex8r/items/91ae1dcc9c3afce7fa8c
}
\defaultfontfeatures{
	WordSpace={.5,1,.3}
}
\setmainfont[Scale=1.2]{kawoszeh}
\setmainjfont{FOT-NewCinemaBStd-D.otf}
\setsansfont[Scale=1.2]{kawoszeh}
\setsansjfont{FOT-TsukuAntiqueLGoStd-B}
\newjfontfamily\hmsjfont[Scale=1]{FOT-TsukuAntiqueSMinStd-L}%横
\newfontfamily\hmsafont[Scale=1]{FOT-TsukuAntiqueSMinStd-L}%横
\newcommand{\hmsfont}{\hmsafont\hmsjfont}
\newjfontfamily\hmnjfont[Scale=1.0]{FOT-HummingPro-D}%カード名
\newfontfamily\hmnafont[Scale=1.2]{kawoszeh}%カード名
\newcommand{\hmnfont}{\hmnafont\hmnjfont}
\newfontfamily\hmcfont[Scale=1.1]{kawoszeh}%コイン
\newjfontfamily\hmsefont[Scale=1]{FOT-RodinNTLGPro-EB}%拡張
\newjfontfamily\hmhafont[Scale=1.0]{FOT-RodinNTLGPro-EB}%家宝
\newfontfamily\hmhjfont[Scale=1.0]{FOT-RodinNTLGPro-EB}%家宝
\newcommand{\hmhfont}{\hmhafont\hmhjfont}
\newfontfamily\hmvafont[Scale=1.1]{kawoszeh}%バニラ
\newjfontfamily\hmvjfont{FOT-HummingPro-D}%バニラ
\newcommand{\hmvfont}{\hmvafont\hmvjfont}
\newjfontfamily\hmajfont[Scale=1]{FOT-TsukuAntiqueSMinStd-L}%注釈
\newfontfamily\hmaafont[Scale=1]{FOT-TsukuAntiqueSMinStd-L}%注釈
\newcommand{\hmafont}{\hmaafont\hmajfont}

\renewcommand{\labelitemi}{\fontspec{nishiki-teki}\ltjalchar`▶︎}

\RequirePackage{pdfrender}
\NewDocumentCommand\hmfukuro{O{.2pt} +m O{white}}{\textpdfrender{
	TextRenderingMode=FillStroke,
	LineWidth=#1,
	FillColor=#3,
}{#2}}

\newlength{\OrigWidth}
%% \hminwidth[*]{«横幅»}{«テキスト»}
% テキストを指定の横幅に"イイカンジに"出力する
% *-> 均等割り付けしない
\NewDocumentCommand\hminwidth{s m m}{{%
	\settowidth{\OrigWidth}{#3}% \settowidth 便利
	\ifthenelse{\lengthtest{\OrigWidth > #2}}{%
		% 指定幅より大きい場合は横方向に縮小する
		\resizebox{#2}{\height}{#3}% 横幅だけ変える
	}{%else
		\IfBooleanTF{#1}{%
			% * 付きで指定幅以下ならそのまま出力
			#3
		}{%
			% 指定幅以下の場合は均等割りを行う
			\kintou{#2}{\jghostguarded{}#3\jghostguarded{}}%
		}%
	}%
}}

\colorlet{gridcolor}{cyan!60}

\colorlet{アクション}{White}
\colorlet{財宝}{Yellow}
\colorlet{勝利点}{Green}
\colorlet{リアクション}{SkyBlue}
\colorlet{持続}{YellowOrange}
\colorlet{避難所}{WildStrawberry}
\colorlet{廃墟}{Peach}
\colorlet{リザーブ}{Apricot}
\colorlet{夜行}{Gray}
\colorlet{イベント}{lightgray}
\colorlet{ランドマーク}{olive}
\colorlet{祝福}{yellow}
\colorlet{呪詛}{Thistle}
\colorlet{状態}{pink}
\colorlet{アーティファクト}{Tan}
\colorlet{プロジェクト}{Lavender}
\colorlet{習性}{CornflowerBlue}
\colorlet{家宝}{Goldenrod}
\colorlet{基本}{OliveGreen}
\colorlet{基本2nd}{OliveGreen}
\colorlet{陰謀}{ForestGreen}
\colorlet{陰謀2nd}{ForestGreen}
\colorlet{海辺}{ProcessBlue}
\colorlet{錬金術}{Violet}
\colorlet{繁栄}{LimeGreen}
\colorlet{収穫祭}{BurntOrange}
\colorlet{異郷}{YellowGreen}
\colorlet{暗黒時代}{Mahogany}
\colorlet{ギルド}{Mulberry}
\colorlet{冒険}{PineGreen}
\colorlet{帝国}{Bittersweet}
\colorlet{夜想曲}{RoyalPurple}
\colorlet{ルネサンス}{SeaGreen}
\colorlet{移動動物園}{Orange}
\colorlet{プロモ}{Black}

\newcommand{\PlusAct}[1]{{\hmvfont\(+\text{#1}\) アクション}}
\newcommand{\PlusBuy}[1]{{\hmvfont\(+\text{#1}\) 購入}}
\newcommand{\PlusCard}[1]{{\hmvfont\(+\text{#1}\) ドロー}}
\newcommand{\PlusCoin}[1]{{\hmvfont\(+\Coin{#1}\)}}
\newcommand{\PlusVP}[1]{{\hmvfont\(+\text{#1}\)\VP}}
\newcommand{\PlusCoffer}[1]{{\hmvfont\(+\text{#1}\) 財源}}
\newcommand{\PlusVillager}[1]{{\hmvfont\(+\text{#1}\) 村人}}
\newcommand{\hmbar}{\par\hspace*{2\zw}\hrulefill\hspace*{2\zw}\par}

\newcommand{\・}{\mbox{・}}
\catcode`　\active \newcommand{　}{\mbox{\　}}

\NewDocumentCommand\Coin{m s t+}{%
	\tikz[baseline=(T.base)]{
		\draw
		node[anchor=center,inner sep=0pt,outer sep=0pt,](T){\includegraphics[height=1.1\zh]{Coin.png}}
		node[anchor=center,inner sep=0pt,outer sep=0pt,font=\hmcfont](T)
		{\textcolor{black}{#1\textsuperscript{\IfBooleanT{#2}{*}\IfBooleanT{#3}{+}}}}
		node[anchor=center,inner sep=0pt,outer sep=0pt,font=\hmcfont](T){\phantom{1}};
	}%
}
\NewDocumentCommand\Debt{m}{%
	\tikz[baseline=(T.base)]{
		\draw
		node[anchor=center,inner sep=0pt,outer sep=0pt,](T){\includegraphics[height=1.1\zh]{Debt.png}}
		node[anchor=center,inner sep=0pt,outer sep=0pt,font=\hmcfont](T){\textcolor{white}{#1}}
		node[anchor=center,inner sep=0pt,outer sep=0pt,font=\hmcfont](T){\phantom{1}};
	}%
}
\NewDocumentCommand\VP{o}{%
	\IfValueT{#1}{#1}%
	\tikz[baseline=(T.base)]{
		\draw
		node[anchor=center,inner sep=0pt,outer sep=0pt,](T){\includegraphics[height=1.1\zh]{VP.png}}
		node[anchor=center,inner sep=0pt,outer sep=0pt,font=\hmcfont](T){\phantom{1}};
	}%
}
\NewDocumentCommand\Potion{}{%
	\tikz[baseline=(T.base)]{
		\draw
		node[anchor=center,inner sep=0pt,outer sep=0pt,](T){\includegraphics[height=1.1\zh]{Potion.png}}
		node[anchor=center,inner sep=0pt,outer sep=0pt,font=\hmcfont](T){\phantom{1}};
	}%
}

\define@cmdkeys{vanilla}[vanilla@]{card,action,buy,coin,coffer,villager,VP}
\NewDocumentCommand\Vanilla{d() o m}{%
	\begin{center}
		\setkeys{vanilla}{#3}%
		\IfValueT{#1}{{\Huge\Coin{#1}}\\}
		\IfValueT{#2}{{\Huge\VP[#2]}\\}
		\large
		\ifthenelse{\isundefined{\vanilla@card}}{}{\PlusCard{\vanilla@card}\\}
		\ifthenelse{\isundefined{\vanilla@action}}{}{\PlusAct{\vanilla@action}\\}
		\ifthenelse{\isundefined{\vanilla@buy}}{}{\PlusBuy{\vanilla@buy}\\}
		\ifthenelse{\isundefined{\vanilla@coin}}{}{\PlusCoin{\vanilla@coin}\\}
		\ifthenelse{\isundefined{\vanilla@coffer}}{}{\PlusCoffer{\vanilla@coffer}\\}
		\ifthenelse{\isundefined{\vanilla@villager}}{}{\PlusVillager{\vanilla@villager}\\}
		\ifthenelse{\isundefined{\vanilla@VP}}{}{\PlusVP{\vanilla@VP}\\}
	\end{center}
	\medskip
}

\define@cmdkeys{info}[]{MC,Cost,CostA,Type,Color,ColorB,Expantion,Artwork,家宝,Copy}
\define@key{info}{トラベラー}[トラベラー]{\def\Travelar{#1}}
\NewDocumentCommand\CardInfo{m m t+ s o m +o +m o}{{%
	\newcommand{\CardNameEN}{#1}%
	\newcommand{\CardNameJA}{#2}%
	\newboolean{shortname}\setboolean{shortname}{false}%
	\newboolean{issuply}\setboolean{issuply}{false}%
	\newboolean{ispile}\setboolean{ispile}{false}%
	\IfBooleanT{#3}{\setboolean{shortname}{true}}%
	\IfBooleanT{#4}{\setboolean{issuply}{true}}%
	\IfValueT{#5}{\newcommand{\AdditionalCard}{#5}}%
	\setkeys{info}{#6}%
	\ifthenelse{\isundefined{\Type}}{\def\Type{アクション}}{}%
	\ifthenelse{\isundefined{\CostA}}{\def\CostA{\Coin{\Cost}}}{}%
	\ifthenelse{\equal{\Type}{財宝}}{\def\Color{財宝}}{}%
	\ifthenelse{\equal{\Type}{勝利点}}{\def\Color{勝利点}}{}%
	\ifthenelse{\equal{\Type}{夜行}}{\def\Color{夜行}}{}%
	\ifthenelse{\equal{\Type}{呪い}}{\def\Color{呪い}}{}%
	\ifthenelse{\isundefined{\Color}}{\def\Color{アクション}}{}%
	\ifthenelse{\isundefined{\ColorB}}{\let\ColorB\Color}{\let\ColorBa\ColorB}%
	\providecommand{\Artwork}{test.pdf}%
	\IfValueT{#7}{\setboolean{ispile}{true}\newcommand{\Alert}{#7}}%
	\newcommand{\Text}{#8}%
	\IfValueT{#9}{\def\errata{#9}}%
	\begin{tikzpicture}[x=1mm,y=1mm]
		\setlength{\parindent}{1\zw}
		% 座標
		\coordinate(OL1)at(63,88);\coordinate(OL3)at(0,0);
		\coordinate(OLE1)at(58,89);\coordinate(OOOO)at(63,89);
		\coordinate(OLE4)at(OLE1|-OL3);
		\coordinate(OOL1)at($(OL1)+(3,3)-(0,.71pt)$);
		\coordinate(OOL3)at($(OL3)-(3,3)-(0,.71pt)$);
		\coordinate(N3)at(3,75);\coordinate(NE1)at(55,85);\coordinate(NJ1)at(55,82);
		\coordinate(NE3)at(NJ1-|N3);\coordinate(NE2)at(NE1-|N3);
		\coordinate(A1)at(54,75);\coordinate(T1)at(54,39);\coordinate(T3)at(4,8);
		\coordinate(A3)at(T1-|T3);
		\coordinate(Y1)at(55,8);\coordinate(Y3)at(3,3);
		\coordinate(Y2)at(Y1-|Y3);\coordinate(Y4)at(Y1|-Y3);
		\coordinate(SE)at(58,77);\coordinate(SN)at(SE);
		\coordinate(SC)at(58,39);\coordinate(SY)at(SC);
		\coordinate(SYC1)at($(SY)+(8,-10)$);\coordinate(SYC2)at(SY|-SYC1);
		\coordinate(SYC4)at($(SYC1)+(0,-10)$);
		\coordinate(CB)at($(Y3)+(2.5,2.5)$);
		\coordinate(CTL)at($(NE2)+(2,-2)$);\coordinate(CTR)at($(NE1)+(-2,-2)$);
		% 外枠
		\useasboundingbox(OL1)rectangle(OL3);
		% カード名
		\shadedraw[top color=\Color,bottom color=\ColorB](N3)rectangle(NE1);
		\path(N3)--(NJ1)node[midway,font=\hmnfont\fontsize{6mm}{0}\selectfont]
			{\hminwidth{48mm}{\ifthenelse{\boolean{shortname}}{　\CardNameJA　}{\CardNameJA}}};
		\path(NE3)--(NE1)node[midway,font=\hmnfont]{\CardNameEN};
		% 出力コイン
		\ifthenelse{\isundefined{\MC}}{}{
			\path(CTL)node[anchor=center,font=\fontsize{4mm}{0}\selectfont]{\Coin{\MC}};
			\path(CTR)node[anchor=center,font=\fontsize{4mm}{0}\selectfont]{\Coin{\MC}};
		}
		% イラスト
		\draw[path picture={\node at (path picture bounding box.center)
			{\includegraphics[width=50mm,height=36mm,keepaspectratio,min size={50mm}{36mm},clip]
			{\Artwork}};}](A1)-|(A3)-|cycle;
		% テキスト
		\shadedraw[top color=\Color,bottom color=\ColorB](T3)rectangle(T1);
		%% トラベラー
		\ifthenelse{\isundefined{\Travelar}}{}{
			\path(T1)--(T3)node
				[midway,font=\fontspec{nishiki-teki}\fontsize{30mm}{0}\selectfont,color=lightgray]{🠝};
		}
		\path(T1)--(T3)node
			[midway,anchor=center,outer sep=0,inner sep=1mm,text width=47.5mm,text justified,color=black]{
				\Text
				\ifthenelse{\boolean{issuply}}{
					\medskip
					\begin{center}
						\hmafont\small （このカードはサプライに置かない）
					\end{center}
				}{}%
				\ifthenelse{\boolean{ispile}}{
					\medskip
					\begin{center}
						\hmafont\hminwidth*{45mm}{\small （\Alert）}
					\end{center}
				}{}%
			};
		% 家宝
		\ifthenelse{\isundefined{\家宝}}{}{
			\path(Y1)--(Y2)node[midway,above,inner sep=0pt,outer sep=0pt,font=\hmhfont]
				{\colorbox{家宝}{\hmfukuro{家宝: \家宝}}};
		}
		% タイプ
		\shadedraw[top color=\Color,bottom color=\ColorB]
			(Y3)rectangle(Y1)node[midway,font=\hmnfont\fontsize{3.5mm}{0}\selectfont]
			{\hminwidth*{42mm}{\Type}};
		% コスト
		\path(CB)node[anchor=center,font=\fontsize{5.4mm}{0}\selectfont]{\CostA};
		% 拡張
		\fill[fill=\Expantion]($(OOOO)+(3,2)$)rectangle(SE)
			node[anchor=south east,rotate=-90,inner ysep=.25mm,font=\hmsefont\fontsize{4mm}{0}\selectfont]
			{\hminwidth{8mm}{\hmfukuro{\Expantion}}};
		% カード名横
		\path(SN)node[anchor=south west,rotate=-90,inner ysep=.25mm,font=\hmsfont]
			{\hminwidth*{31mm}{%
				\ltjsetparameter{autoxspacing=false}%
				\fontsize{4mm}{0}\selectfont%
				\ifthenelse{\boolean{issuply}}{★}{}%
				\ifthenelse{\boolean{ispile}}{☆}{}%
				\CardNameJA%
				\fontsize{2.5mm}{0}\color{darkgray}\selectfont%
				\ifthenelse{\isundefined{\Copy}}{}{/\Copy 枚}%
				\ifthenelse{\isundefined{\AdditionalCard}}{}{{\fontspec{nishiki-teki}🠾}\AdditionalCard}%
			}};
		% コスト横
		\path(SC)node[anchor=south east,rotate=-90,inner ysep=.25mm,font=\fontsize{3.5mm}{0}\selectfont]
			{\CostA};
		% タイプ横
		\fill[\Color](SY)rectangle(SYC1);
		\ifthenelse{\isundefined{\ColorBa}}{}{\fill[\ColorBa](SYC2)rectangle(SYC4);}
		\path(SY)node[anchor=south west,rotate=-90,inner ysep=.25mm,font=\hmsfont\color{blue}]
			{\hminwidth*{35mm}{\Type}};
		% エラッタ年度
		\path(Y4)node[anchor=south east,inner sep=.25mm]{\tiny\errata};
		% 方眼
		\draw[thin]($(OLE1)+(0,2)$)--($(OLE4)+(0,-3)$);
		\ifgrid
			\draw[very thin,gridcolor,nearly transparent](OOOO)grid[step=1](OL3);
			\draw[thin,gridcolor,nearly transparent](OOOO)grid[step=10](OL3);
			\draw[thin,gridcolor,nearly transparent](OL1)rectangle(OL3);
			\draw[thin,gridcolor,nearly transparent](OLE1)rectangle(OLE4);
		\fi
	\end{tikzpicture}%
	\pagebreak
}}

\define@cmdkeys{info-l}[]{Cost,CostA,Type,Expantion,Artwork,Copy}
\NewDocumentCommand\LandscapeInfo{m m t+ o d() m +m o}{{%
	\newcommand{\CardNameEN}{#1}%
	\newcommand{\CardNameJA}{#2}%
	\newboolean{shortname}\setboolean{shortname}{false}%
	\IfBooleanT{#3}{\setboolean{shortname}{true}}%
	\IfValueT{#4}{\newcommand{\AdditionalCard}{#4}}%
	\IfValueT{#5}{\newcommand{\FromCard}{#5}}%
	\setkeys{info-l}{#6}%
	\ifthenelse{\isundefined{\Cost}}{}{\def\CostA{\Coin{\Cost}}}%
	\ifthenelse{\isundefined{\Color}}{\def\Color{\Type}}{}%
	\providecommand{\Artwork}{test-l.pdf}%
	\newcommand{\Text}{#7}%
	\IfValueT{#8}{\def\errata{#8}}%
	\begin{tikzpicture}[x=1mm,y=1mm]
		\setlength{\parindent}{1\zw}
		% 座標
		\coordinate(OL1)at(0,63);\coordinate(OL3)at(88,0);
		\coordinate(OLE1)at(-1,58);\coordinate(OOOO)at(-1,63);
		\coordinate(OLE4)at(OLE1-|OL3);
		\coordinate(OOL1)at($(OL1)+(3,3)-(0,.71pt)$);
		\coordinate(OOL3)at($(OL3)-(3,3)-(0,.71pt)$);
		\coordinate(N3)at(18,45);\coordinate(NE1)at(70,55);\coordinate(NJ1)at(70,52);
		\coordinate(NE3)at(NJ1-|N3);\coordinate(NE2)at(NE1-|N3);
		\coordinate(A1)at(84,48);\coordinate(T1)at(84,28);\coordinate(T3)at(4,3);
		\coordinate(A3)at(T1-|T3);\coordinate(A2)at(A1-|A3);\coordinate(T4)at(T1|-T3);
		\coordinate(CB)at($(A2)+(-1,0)$);
		\coordinate(Y1)at(71,50);\coordinate(Y2)at(86,35);
		\coordinate(SE)at(11,58);\coordinate(SN)at(SE);
		\coordinate(SC)at(49,58);\coordinate(SY)at(SC);
		\coordinate(SYC1)at($(SY)+(10,8)$);
		% 外枠
		\useasboundingbox(OL1)rectangle(OL3);
		% イラスト、タイプ
		\draw[path picture={\node at (path picture bounding box.center)
			{\includegraphics[width=80mm,height=20mm,keepaspectratio,min size={80mm}{20mm},clip]{\Artwork}};
			\draw[black,line width=3mm+1pt](Y1)--(Y2);
			\draw[\Color,line width=3mm](Y1)--(Y2)node[midway,sloped,font=\hmnfont,color=black]{\hminwidth*{10mm}{\Type}};
		}](A1)-|(A3)-|cycle;
		% カード名
		\filldraw[fill=\Color](N3)rectangle(NE1);
		\path(N3)--(NJ1)node[midway,font=\hmnfont\fontsize{6mm}{0}\selectfont]
			{\hminwidth{48mm}{\ifthenelse{\boolean{shortname}}{　\CardNameJA　}{\CardNameJA}}};
		\path(NE3)--(NE1)node[midway,font=\hmnfont]{\CardNameEN};
		% テキスト
		\filldraw[fill=\Color](T3)rectangle(T1);
		\path(T1)--(T3)node
			[midway,anchor=center,outer sep=0,inner sep=1mm,text width=47.5mm,text justified,color=black]{
				\Text
			};
		% コスト
		\ifthenelse{\isundefined{\CostA}}{}
			{\path(CB)node[anchor=west,inner sep=0pt,font=\fontsize{5.4mm}{0}\selectfont]{\CostA};}
		% 拡張
		\fill[fill=\Expantion]($(OOOO)+(-2,3)$)rectangle(SE)
			node[anchor=south east,inner ysep=.25mm,font=\hmsefont\fontsize{4mm}{0}\selectfont]
			{\hminwidth{8mm}{\hmfukuro{\Expantion}}};
		% カード名横
		\path(SN)node[anchor=south west,inner ysep=.25mm,font=\hmsfont]
			{\hminwidth*{31mm}{%
				\ltjsetparameter{autoxspacing=false}%
				\fontsize{4mm}{0}\selectfont%
				◎%
				\CardNameJA%
				\fontsize{2.5mm}{0}\color{darkgray}\selectfont%
				\ifthenelse{\isundefined{\Copy}}{}{/\Copy 枚}%
				\ifthenelse{\isundefined{\AdditionalCard}}{}{{\fontspec{nishiki-teki}🠾}\AdditionalCard}%
				\ifthenelse{\isundefined{\FromCard}}{}{\<（{\fontspec{nishiki-teki}🠼}\FromCard ）\<}%
			}};
		% コスト横
		\ifthenelse{\isundefined{\CostA}}{}{
			\path(SC)node[anchor=south east,inner ysep=.25mm,font=\fontsize{3.5mm}{0}\selectfont]
				{\CostA};
		}
		% タイプ横
		\fill[\Color](SY)rectangle(SYC1);
		\path(SY)node[anchor=south west,inner ysep=.25mm,font=\hmsfont\color{blue}]
			{\hminwidth*{35mm}{\Type}};
		% エラッタ年度
		\path(T4)node[anchor=south east,inner sep=.25mm]{\tiny\errata};
		% 方眼
		\draw[thin]($(OLE1)+(-2,0)$)--($(OLE4)+(3,0)$);
		\ifgrid
			\draw[very thin,gridcolor,nearly transparent](OOOO)grid[step=1](OL3);
			\draw[thin,gridcolor,nearly transparent](OOOO)grid[step=10](OL3);
			\draw[thin,gridcolor,nearly transparent](OL1)rectangle(OL3);
			\draw[thin,gridcolor,nearly transparent](OLE1)rectangle(OLE4);
		\fi
	\end{tikzpicture}%
	\pagebreak
}}
\pagestyle{empty}
\setlength{\parindent}{0pt}
