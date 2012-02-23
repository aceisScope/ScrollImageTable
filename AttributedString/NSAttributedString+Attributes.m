/***********************************************************************************
 *
 * Copyright (c) 2010 Olivier Halligon
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 ***********************************************************************************
 *
 * Created by Olivier Halligon  (AliSoftware) on 20 Jul. 2010.
 *
 * Any comment or suggestion welcome. Please contact me before using this class in
 * your projects. Referencing this project in your AboutBox/Credits is appreciated.
 *
 ***********************************************************************************/


#import "NSAttributedString+Attributes.h"


/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: NS(Mutable)AttributedString Additions
/////////////////////////////////////////////////////////////////////////////

@implementation NSAttributedString (OHCommodityConstructors)
+(id)attributedStringWithString:(NSString*)string {
	return string ? [[[self alloc] initWithString:string] autorelease] : nil;
}
+(id)attributedStringWithAttributedString:(NSAttributedString*)attrStr {
	return attrStr ? [[[self alloc] initWithAttributedString:attrStr] autorelease] : nil;
}

- (CGSize) sizeConstrainedToWidth:(CGFloat)width {
    [self retain];
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) self);
	CGSize sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0,0),NULL,CGSizeMake(width,CGFLOAT_MAX),NULL);
	if (framesetter) CFRelease(framesetter);
    [self autorelease];
	return sz;
}

- (NSAttributedString*) attributedStringWithLinks {
    NSMutableAttributedString* str = [self mutableCopy];    
    NSError* error = nil;
    NSDataDetector* linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSArray *matches = [linkDetector matchesInString:[str string]
                                             options:0
                                               range:NSMakeRange(0, [str length])];
    for (NSTextCheckingResult *result in matches) {
        int32_t uStyle = kCTUnderlineStyleSingle; // : kCTUnderlineStyleNone;
        UIColor* thisLinkColor = [UIColor blueColor];
        
        if (thisLinkColor)
            [str setTextColor:thisLinkColor range:[result range]];
        if (uStyle>0)
            [str setTextUnderlineStyle:uStyle range:[result range]];
    }
    
    return [str autorelease];
}

@end

@implementation NSMutableAttributedString (OHCommodityStyleModifiers)

-(void)setSkewedFontWithName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range {
	// kCTFontAttributeName
	CGAffineTransform transform = CGAffineTransformMake(1, 0, 0.25, 1., 0., 0.);	// 0.25 ~ tan(14/360*2*Pi);
	CTFontRef aFont = CTFontCreateWithName((CFStringRef)fontName, size, &transform);
	if (!aFont) return;
	[self removeAttribute:(NSString*)kCTFontAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTFontAttributeName value:(id)aFont range:range];
	CFRelease(aFont);
}

- (void) setSkewedFontWithName:(NSString*)fontName size:(CGFloat)size{
	[self setSkewedFontWithName:fontName size:size range:NSMakeRange(0, [self length])];
}

-(void)setFont:(UIFont*)font {
	[self setFontName:font.fontName size:font.pointSize];
}
-(void)setFont:(UIFont*)font range:(NSRange)range {
	[self setFontName:font.fontName size:font.pointSize range:range];
}
-(void)setFontName:(NSString*)fontName size:(CGFloat)size {
	[self setFontName:fontName size:size range:NSMakeRange(0,[self length])];
}
-(void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range {
	// kCTFontAttributeName
	CTFontRef aFont = CTFontCreateWithName((CFStringRef)fontName, size, NULL);
	if (!aFont) return;
	[self removeAttribute:(NSString * )kCTFontAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTFontAttributeName value:(id)aFont range:range];
	CFRelease(aFont);
}
-(void)setFontFamily:(NSString*)fontFamily size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic range:(NSRange)range {
	// kCTFontFamilyNameAttribute + kCTFontTraitsAttribute
	CTFontSymbolicTraits symTrait = (isBold?kCTFontBoldTrait:0) | (isItalic?kCTFontItalicTrait:0);
	NSDictionary* trait = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:symTrait] forKey:(NSString*)kCTFontSymbolicTrait];
	NSDictionary* attr = [NSDictionary dictionaryWithObjectsAndKeys:
						  fontFamily,kCTFontFamilyNameAttribute,
						  trait,kCTFontTraitsAttribute,nil];
	
	CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attr);
	if (!desc) return;
	CTFontRef aFont = CTFontCreateWithFontDescriptor(desc, size, NULL);
	CFRelease(desc);
	if (!aFont) return;

	[self removeAttribute:(NSString * )kCTFontAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTFontAttributeName value:(id)aFont range:range];
	CFRelease(aFont);
}

- (void)setChineseFontName:(NSString*)cFontName asciiFontName:(NSString*)eFontName size:(CGFloat)fontSize
{
	NSString * string = [self string];
	int start_index = 0, len = string.length;
	while (start_index < len) {
		BOOL isChinese = ([string characterAtIndex:start_index] > 0x7f);
		NSString * fontName = (isChinese ? cFontName : eFontName);
		CGFloat size = ( isChinese ? fontSize : fontSize);
		
		int end_index = start_index+1;
		while (end_index < len) {
			BOOL newCharIsChinese = ([string characterAtIndex:end_index] > 0x7f);
			if (newCharIsChinese != isChinese) break;
			end_index ++;
		}
		
		NSRange range = NSMakeRange(start_index, end_index - start_index);
		[self setFontName:fontName size:size range:range];
		
		start_index = end_index;
	}
}

-(void)setTextColor:(UIColor*)color {
	[self setTextColor:color range:NSMakeRange(0,[self length])];
}
-(void)setTextColor:(UIColor*)color range:(NSRange)range {
	// kCTForegroundColorAttributeName
	[self removeAttribute:(NSString * )kCTForegroundColorAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
}

-(void)setTextIsUnderlined:(BOOL)underlined {
	[self setTextIsUnderlined:underlined range:NSMakeRange(0,[self length])];
}
-(void)setTextIsUnderlined:(BOOL)underlined range:(NSRange)range {
	int32_t style = underlined ? (kCTUnderlineStyleSingle|kCTUnderlinePatternSolid) : kCTUnderlineStyleNone;
	[self setTextUnderlineStyle:style range:range];
}
-(void)setTextUnderlineStyle:(int32_t)style range:(NSRange)range {
	[self removeAttribute:(NSString * )kCTUnderlineStyleAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:style] range:range];
}

-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode {
	[self setTextAlignment:alignment lineBreakMode:lineBreakMode range:NSMakeRange(0,[self length])];
}
-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode range:(NSRange)range {
	// kCTParagraphStyleAttributeName > kCTParagraphStyleSpecifierAlignment
	CTParagraphStyleSetting paraStyles[2] = {
		{.spec = kCTParagraphStyleSpecifierAlignment, .valueSize = sizeof(CTTextAlignment), .value = (const void*)&alignment},
		{.spec = kCTParagraphStyleSpecifierLineBreakMode, .valueSize = sizeof(CTLineBreakMode), .value = (const void*)&lineBreakMode},
	};
	CTParagraphStyleRef aStyle = CTParagraphStyleCreate(paraStyles, 2);
	[self addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(id)aStyle range:range];
	CFRelease(aStyle);
}


- (void)setLineHeightMultiple:(CGFloat)lineheightmultiple
{
	CTParagraphStyleSetting paraStyles[1] = {
		{.spec = kCTParagraphStyleSpecifierLineHeightMultiple, .valueSize = sizeof(CGFloat), .value = (const void*)&lineheightmultiple},
	};
	CTParagraphStyleRef aStyle = CTParagraphStyleCreate(paraStyles, 1);
	[self addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(id)aStyle range:NSMakeRange(0, [self length])];
	CFRelease(aStyle);
}

- (void)setLineSpacingAdjustment:(CGFloat)lineSpacing
{
	CTParagraphStyleSetting paraStyles[1] = {
		//		{.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment, .valueSize = sizeof(CGFloat), .value = (const void*)&lineSpacing},
		{.spec = kCTParagraphStyleSpecifierLineSpacing, .valueSize = sizeof(CGFloat), .value = (const void*)&lineSpacing},
	};           
	CTParagraphStyleRef aStyle = CTParagraphStyleCreate(paraStyles, 1);
	[self addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(id)aStyle range:NSMakeRange(0, [self length])];
	CFRelease(aStyle);
}


- (void)setParagraphSpacing:(CGFloat)spacing
{
	CTParagraphStyleSetting paraStyles[1] = {
		{.spec = kCTParagraphStyleSpecifierParagraphSpacing, .valueSize = sizeof(CGFloat), .value = (const void*)&spacing},
	};
	CTParagraphStyleRef aStyle = CTParagraphStyleCreate(paraStyles, 1);
	[self addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(id)aStyle range:NSMakeRange(0, [self length])];
	CFRelease(aStyle);
}

- (void)setParagraphSpacingBefore:(CGFloat)spacing
{
	CTParagraphStyleSetting paraStyles[1] = {
		{.spec = kCTParagraphStyleSpecifierParagraphSpacingBefore, .valueSize = sizeof(CGFloat), .value = (const void*)&spacing},
	};
	CTParagraphStyleRef aStyle = CTParagraphStyleCreate(paraStyles, 1);
	[self addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(id)aStyle range:NSMakeRange(0, [self length])];
	CFRelease(aStyle);
}

- (void)setStrokePercentage:(CGFloat)widthPercentage
{
    CFNumberRef num = (CFNumberRef) [NSNumber numberWithFloat:widthPercentage];
	[self addAttribute:(NSString*)kCTStrokeWidthAttributeName value:(id)num range:NSMakeRange(0, [self length])];
}

- (void)setStrokeColor:(UIColor*) strokeColor
{
	[self addAttribute:(NSString*)kCTStrokeColorAttributeName value:(id)strokeColor.CGColor range:NSMakeRange(0, [self length])];
}

@end


