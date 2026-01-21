// To parse this JSON data, use:
// final res = IpoOpenResponse.fromJson(jsonDecode(jsonString));

class IpoOpenResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final String? timestamp;
  final IpoOpenPayload? data;

  IpoOpenResponse({
    this.success,
    this.statusCode,
    this.message,
    this.timestamp,
    this.data,
  });

  factory IpoOpenResponse.fromJson(Map<String, dynamic> json) {
    return IpoOpenResponse(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      timestamp: json['timestamp'] as String?,
      data: json['data'] == null
          ? null
          : IpoOpenPayload.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status_code': statusCode,
      'message': message,
      'timestamp': timestamp,
      'data': data?.toJson(),
    };
  }
}

class IpoOpenPayload {
  final String? endpoint;
  final int? totalRecords;
  final List<IpoItem>? data;

  IpoOpenPayload({
    this.endpoint,
    this.totalRecords,
    this.data,
  });

  factory IpoOpenPayload.fromJson(Map<String, dynamic> json) {
    return IpoOpenPayload(
      endpoint: json['endpoint'] as String?,
      totalRecords: (json['total_records'] as num?)?.toInt(),
      data: (json['data'] as List?)
          ?.map((e) => IpoItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'endpoint': endpoint,
      'total_records': totalRecords,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class IpoItem {
  final String? id;
  final int? ipoId;

  final String? apiCompanyName;
  final String? apiIpoStatus;
  final String? apiIpoStatusFormatted;

  final dynamic apiListedPrice;
  final dynamic apiListingGain;

  final int? apiGmpValue;
  final double? apiGmpPercent;

  final String? apiFireRating;
  final int? apiFireRatingCount;

  final String? apiSubscription;

  final dynamic apiPrice;
  final dynamic apiEstimatedListingPrice;
  final dynamic apiEstimatedListingPercent;

  final String? apiIssueSize;
  final String? apiLot;
  final double? apiPe;

  final String? apiIssueOpenDate;
  final String? apiIssueCloseDate;
  final String? apiBoaDate;
  final String? apiListingAt;

  final String? apiUrl;
  final String? apiIpoCategory;
  final int? apiIpoYear;

  final String? scrapingDate;
  final String? detailUrl;

  final String? scrapedCompanyName;
  final String? companyLogoUrl;
  final String? localLogoPath;
  final String? companyFullNameScraped;

  final String? aboutCompanyText;
  final String? minOrderQuantityScraped;
  final String? sharesPerLotScraped;
  final String? ipoSummaryText;

  final String? ipoIssueOpeningDateStatus;
  final String? ipoIssueOpeningDateParsed;
  final String? ipoIssueClosingDateStatus;
  final String? ipoIssueClosingDateParsed;

  final String? ipoOpenDate;
  final String? ipoCloseDate;
  final String? basisOfAllotment;
  final String? initiationOfRefunds;
  final String? creditOfSharesToDemat;
  final String? listingDate;

  final String? ipoOpenDateStatus;
  final String? ipoOpenDateParsed;
  final String? ipoCloseDateStatus;
  final String? ipoCloseDateParsed;
  final String? listingDateStatus;
  final String? listingDateParsed;
  final String? basisOfAllotmentStatus;
  final String? basisOfAllotmentParsed;
  final String? initiationOfRefundsStatus;
  final String? initiationOfRefundsParsed;
  final String? creditOfSharesToDematStatus;
  final String? creditOfSharesToDematParsed;

  final String? lotIssuePrice;
  final String? lotMarketLot;
  final String? lotRetailMin;
  final String? lotIndividualInvestor;
  final String? lotMinHniLots;
  final String? lotMinSmallHniLots210Lakh;
  final String? lotMinBigHniLots10PlusLakh;

  final String? seq;

  final String? idGmpData;
  final String? ipoIdGmpData;
  final String? gmpDate;
  final String? currentGmp;
  final String? gmpComments;
  final String? gmpCompareDesc;

  final String? subjectToSauda;
  final String? gmpCity;
  final String? gmpVariation;

  final String? maxIpoPrice;
  final String? estimatedListingPrice;
  final String? gmpPercentCalc;
  final String? gmpDescOther;
  final String? upDownStatus;
  final String? gmpActiveRecordFlag;

  final String? sub2SaudaRate;
  final String? estProfit;

  final String? createDate;
  final String? createDateGmp;
  final String? lastUpdatedGmp;
  final String? lastUpdated;

  final String? ipoIssueOpeningDateTable;
  final String? ipoIssueClosingDateTable;
  final String? ipoIssuePriceTable;

  final String? drhpLinkTable;
  final String? rhpLinkTable;
  final String? anchorListLinkTable;

  final String? listingAtTable;
  final String? retailQuotaTable;

  final String? ipoIssueTypeTable;
  final String? ipoIssueSizeTable;

  final String? freshIssueTable;
  final dynamic offerForSaleTable;

  final String? faceValueTable;
  final String? ipoDiscountTable;

  final String? promoterHoldingPreIpoTable;
  final String? promoterHoldingPostIpoTable;

  final String? minOrderQuantityTable;
  final String? lotSizeTable;

  final String? allotmentStatusTable;
  final String? ipoBseCodeTable;
  final String? ipoNseCodeTable;

  final String? lastUpdatedTimestamp;

  final String? metaTitle;
  final String? pageTitle;
  final String? metaDesc;

  final String? cacheKey;
  final String? currentTime;

  final String? scrapedAt;

  final String? companyFullName;
  final String? companyFullNameNew;

  final String? ipoAnchorText;

  final List<IpoShareAllocation>? ipoShareAllocation;

  final IpoDaywiseSubscriptionTable? ipoDaywiseSubscriptionTable;

  final List<IpoSharesBidAmount>? ipoSharesBidAmountTable;

  final List<Map<String, dynamic>>? ipoBiddingHistoryJson;

  final List<GmpTrendHistory>? gmpTrendHistoryTable;

  final List<String>? strengths;

  final List<IpoObjective>? objectives;

  final List<FinancialMetricRow>? companyFinancialInformationRestatedConsolidated;

  final List<PeerComparisonRow>? peerComparison;

  final Map<String, dynamic>? ipoAnchorGeneralInfo;

  final CompanyAddress? companyAddress;
  final IpoRegistrar? ipoRegistrar;

  final List<String>? ipoLeadManager;

  final CompanySectorInfo? companySectorInfo;

  final List<dynamic>? ipoAnchorInvestorAllocation;

  final String? timestamp;
  final String? lastUpdatedDb;
  final String? createdAtDb;

  final String? updatedAt;
  final String? createdAt;

  IpoItem({
    this.id,
    this.ipoId,
    this.apiCompanyName,
    this.apiIpoStatus,
    this.apiIpoStatusFormatted,
    this.apiListedPrice,
    this.apiListingGain,
    this.apiGmpValue,
    this.apiGmpPercent,
    this.apiFireRating,
    this.apiFireRatingCount,
    this.apiSubscription,
    this.apiPrice,
    this.apiEstimatedListingPrice,
    this.apiEstimatedListingPercent,
    this.apiIssueSize,
    this.apiLot,
    this.apiPe,
    this.apiIssueOpenDate,
    this.apiIssueCloseDate,
    this.apiBoaDate,
    this.apiListingAt,
    this.apiUrl,
    this.apiIpoCategory,
    this.apiIpoYear,
    this.scrapingDate,
    this.detailUrl,
    this.scrapedCompanyName,
    this.companyLogoUrl,
    this.localLogoPath,
    this.companyFullNameScraped,
    this.aboutCompanyText,
    this.minOrderQuantityScraped,
    this.sharesPerLotScraped,
    this.ipoSummaryText,
    this.ipoIssueOpeningDateStatus,
    this.ipoIssueOpeningDateParsed,
    this.ipoIssueClosingDateStatus,
    this.ipoIssueClosingDateParsed,
    this.ipoOpenDate,
    this.ipoCloseDate,
    this.basisOfAllotment,
    this.initiationOfRefunds,
    this.creditOfSharesToDemat,
    this.listingDate,
    this.ipoOpenDateStatus,
    this.ipoOpenDateParsed,
    this.ipoCloseDateStatus,
    this.ipoCloseDateParsed,
    this.listingDateStatus,
    this.listingDateParsed,
    this.basisOfAllotmentStatus,
    this.basisOfAllotmentParsed,
    this.initiationOfRefundsStatus,
    this.initiationOfRefundsParsed,
    this.creditOfSharesToDematStatus,
    this.creditOfSharesToDematParsed,
    this.lotIssuePrice,
    this.lotMarketLot,
    this.lotRetailMin,
    this.lotIndividualInvestor,
    this.lotMinHniLots,
    this.lotMinSmallHniLots210Lakh,
    this.lotMinBigHniLots10PlusLakh,
    this.seq,
    this.idGmpData,
    this.ipoIdGmpData,
    this.gmpDate,
    this.currentGmp,
    this.gmpComments,
    this.gmpCompareDesc,
    this.subjectToSauda,
    this.gmpCity,
    this.gmpVariation,
    this.maxIpoPrice,
    this.estimatedListingPrice,
    this.gmpPercentCalc,
    this.gmpDescOther,
    this.upDownStatus,
    this.gmpActiveRecordFlag,
    this.sub2SaudaRate,
    this.estProfit,
    this.createDate,
    this.createDateGmp,
    this.lastUpdatedGmp,
    this.lastUpdated,
    this.ipoIssueOpeningDateTable,
    this.ipoIssueClosingDateTable,
    this.ipoIssuePriceTable,
    this.drhpLinkTable,
    this.rhpLinkTable,
    this.anchorListLinkTable,
    this.listingAtTable,
    this.retailQuotaTable,
    this.ipoIssueTypeTable,
    this.ipoIssueSizeTable,
    this.freshIssueTable,
    this.offerForSaleTable,
    this.faceValueTable,
    this.ipoDiscountTable,
    this.promoterHoldingPreIpoTable,
    this.promoterHoldingPostIpoTable,
    this.minOrderQuantityTable,
    this.lotSizeTable,
    this.allotmentStatusTable,
    this.ipoBseCodeTable,
    this.ipoNseCodeTable,
    this.lastUpdatedTimestamp,
    this.metaTitle,
    this.pageTitle,
    this.metaDesc,
    this.cacheKey,
    this.currentTime,
    this.scrapedAt,
    this.companyFullName,
    this.companyFullNameNew,
    this.ipoAnchorText,
    this.ipoShareAllocation,
    this.ipoDaywiseSubscriptionTable,
    this.ipoSharesBidAmountTable,
    this.ipoBiddingHistoryJson,
    this.gmpTrendHistoryTable,
    this.strengths,
    this.objectives,
    this.companyFinancialInformationRestatedConsolidated,
    this.peerComparison,
    this.ipoAnchorGeneralInfo,
    this.companyAddress,
    this.ipoRegistrar,
    this.ipoLeadManager,
    this.companySectorInfo,
    this.ipoAnchorInvestorAllocation,
    this.timestamp,
    this.lastUpdatedDb,
    this.createdAtDb,
    this.updatedAt,
    this.createdAt,
  });

  factory IpoItem.fromJson(Map<String, dynamic> json) {
    return IpoItem(
      id: json['_id'] as String?,
      ipoId: (json['ipoId'] as num?)?.toInt(),
      apiCompanyName: json['apiCompanyName'] as String?,
      apiIpoStatus: json['apiIpoStatus'] as String?,
      apiIpoStatusFormatted: json['apiIpoStatusFormatted'] as String?,
      apiListedPrice: json['apiListedPrice'],
      apiListingGain: json['apiListingGain'],
      apiGmpValue: (json['apiGmpValue'] as num?)?.toInt(),
      apiGmpPercent: (json['apiGmpPercent'] as num?)?.toDouble(),
      apiFireRating: json['apiFireRating'] as String?,
      apiFireRatingCount: (json['apiFireRatingCount'] as num?)?.toInt(),
      apiSubscription: json['apiSubscription'] as String?,
      apiPrice: json['apiPrice'],
      apiEstimatedListingPrice: json['apiEstimatedListingPrice'],
      apiEstimatedListingPercent: json['apiEstimatedListingPercent'],
      apiIssueSize: json['apiIssueSize'] as String?,
      apiLot: json['apiLot'] as String?,
      apiPe: (json['apiPe'] as num?)?.toDouble(),
      apiIssueOpenDate: json['apiIssueOpenDate'] as String?,
      apiIssueCloseDate: json['apiIssueCloseDate'] as String?,
      apiBoaDate: json['apiBoaDate'] as String?,
      apiListingAt: json['apiListingAt'] as String?,
      apiUrl: json['apiUrl'] as String?,
      apiIpoCategory: json['apiIpoCategory'] as String?,
      apiIpoYear: (json['apiIpoYear'] as num?)?.toInt(),
      scrapingDate: json['scrapingDate'] as String?,
      detailUrl: json['detailUrl'] as String?,
      scrapedCompanyName: json['scrapedCompanyName'] as String?,
      companyLogoUrl: json['companyLogoUrl'] as String?,
      localLogoPath: json['localLogoPath'] as String?,
      companyFullNameScraped: json['companyFullNameScraped'] as String?,
      aboutCompanyText: json['aboutCompanyText'] as String?,
      minOrderQuantityScraped: json['minOrderQuantityScraped'] as String?,
      sharesPerLotScraped: json['sharesPerLotScraped'] as String?,
      ipoSummaryText: json['ipoSummaryText'] as String?,
      ipoIssueOpeningDateStatus: json['ipoIssueOpeningDateStatus'] as String?,
      ipoIssueOpeningDateParsed: json['ipoIssueOpeningDateParsed'] as String?,
      ipoIssueClosingDateStatus: json['ipoIssueClosingDateStatus'] as String?,
      ipoIssueClosingDateParsed: json['ipoIssueClosingDateParsed'] as String?,
      ipoOpenDate: json['ipoOpenDate'] as String?,
      ipoCloseDate: json['ipoCloseDate'] as String?,
      basisOfAllotment: json['basisOfAllotment'] as String?,
      initiationOfRefunds: json['initiationOfRefunds'] as String?,
      creditOfSharesToDemat: json['creditOfSharesToDemat'] as String?,
      listingDate: json['listingDate'] as String?,
      ipoOpenDateStatus: json['ipoOpenDateStatus'] as String?,
      ipoOpenDateParsed: json['ipoOpenDateParsed'] as String?,
      ipoCloseDateStatus: json['ipoCloseDateStatus'] as String?,
      ipoCloseDateParsed: json['ipoCloseDateParsed'] as String?,
      listingDateStatus: json['listingDateStatus'] as String?,
      listingDateParsed: json['listingDateParsed'] as String?,
      basisOfAllotmentStatus: json['basisOfAllotmentStatus'] as String?,
      basisOfAllotmentParsed: json['basisOfAllotmentParsed'] as String?,
      initiationOfRefundsStatus: json['initiationOfRefundsStatus'] as String?,
      initiationOfRefundsParsed: json['initiationOfRefundsParsed'] as String?,
      creditOfSharesToDematStatus: json['creditOfSharesToDematStatus'] as String?,
      creditOfSharesToDematParsed:
          json['creditOfSharesToDematParsed'] as String?,
      lotIssuePrice: json['lotIssuePrice'] as String?,
      lotMarketLot: json['lotMarketLot'] as String?,
      lotRetailMin: json['lotRetailMin'] as String?,
      lotIndividualInvestor: json['lotIndividualInvestor'] as String?,
      lotMinHniLots: json['lotMinHniLots'] as String?,
      lotMinSmallHniLots210Lakh: json['lotMinSmallHniLots210Lakh'] as String?,
      lotMinBigHniLots10PlusLakh: json['lotMinBigHniLots10PlusLakh'] as String?,
      seq: json['seq'] as String?,
      idGmpData: json['idGmpData'] as String?,
      ipoIdGmpData: json['ipoIdGmpData'] as String?,
      gmpDate: json['gmpDate'] as String?,
      currentGmp: json['currentGmp'] as String?,
      gmpComments: json['gmpComments'] as String?,
      gmpCompareDesc: json['gmpCompareDesc'] as String?,
      subjectToSauda: json['subjectToSauda'] as String?,
      gmpCity: json['gmpCity'] as String?,
      gmpVariation: json['gmpVariation'] as String?,
      maxIpoPrice: json['maxIpoPrice'] as String?,
      estimatedListingPrice: json['estimatedListingPrice'] as String?,
      gmpPercentCalc: json['gmpPercentCalc'] as String?,
      gmpDescOther: json['gmpDescOther'] as String?,
      upDownStatus: json['upDownStatus'] as String?,
      gmpActiveRecordFlag: json['gmpActiveRecordFlag'] as String?,
      sub2SaudaRate: json['sub2SaudaRate'] as String?,
      estProfit: json['estProfit'] as String?,
      createDate: json['createDate'] as String?,
      createDateGmp: json['createDateGmp'] as String?,
      lastUpdatedGmp: json['lastUpdatedGmp'] as String?,
      lastUpdated: json['lastUpdated'] as String?,
      ipoIssueOpeningDateTable: json['ipoIssueOpeningDateTable'] as String?,
      ipoIssueClosingDateTable: json['ipoIssueClosingDateTable'] as String?,
      ipoIssuePriceTable: json['ipoIssuePriceTable'] as String?,
      drhpLinkTable: json['drhpLinkTable'] as String?,
      rhpLinkTable: json['rhpLinkTable'] as String?,
      anchorListLinkTable: json['anchorListLinkTable'] as String?,
      listingAtTable: json['listingAtTable'] as String?,
      retailQuotaTable: json['retailQuotaTable'] as String?,
      ipoIssueTypeTable: json['ipoIssueTypeTable'] as String?,
      ipoIssueSizeTable: json['ipoIssueSizeTable'] as String?,
      freshIssueTable: json['freshIssueTable'] as String?,
      offerForSaleTable: json['offerForSaleTable'],
      faceValueTable: json['faceValueTable'] as String?,
      ipoDiscountTable: json['ipoDiscountTable'] as String?,
      promoterHoldingPreIpoTable: json['promoterHoldingPreIpoTable'] as String?,
      promoterHoldingPostIpoTable: json['promoterHoldingPostIpoTable'] as String?,
      minOrderQuantityTable: json['minOrderQuantityTable'] as String?,
      lotSizeTable: json['lotSizeTable'] as String?,
      allotmentStatusTable: json['allotmentStatusTable'] as String?,
      ipoBseCodeTable: json['ipoBseCodeTable'] as String?,
      ipoNseCodeTable: json['ipoNseCodeTable'] as String?,
      lastUpdatedTimestamp: json['lastUpdatedTimestamp'] as String?,
      metaTitle: json['metaTitle'] as String?,
      pageTitle: json['pageTitle'] as String?,
      metaDesc: json['metaDesc'] as String?,
      cacheKey: json['cacheKey'] as String?,
      currentTime: json['currentTime'] as String?,
      scrapedAt: json['scrapedAt'] as String?,
      companyFullName: json['companyFullName'] as String?,
      companyFullNameNew: json['companyFullNameNew'] as String?,
      ipoAnchorText: json['ipoAnchorText'] as String?,
      ipoShareAllocation: (json['ipoShareAllocation'] as List?)
          ?.map((e) => IpoShareAllocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      ipoDaywiseSubscriptionTable: json['ipoDaywiseSubscriptionTable'] == null
          ? null
          : IpoDaywiseSubscriptionTable.fromJson(
              json['ipoDaywiseSubscriptionTable'] as Map<String, dynamic>,
            ),
      ipoSharesBidAmountTable: (json['ipoSharesBidAmountTable'] as List?)
          ?.map((e) => IpoSharesBidAmount.fromJson(e as Map<String, dynamic>))
          .toList(),
      ipoBiddingHistoryJson: (json['ipoBiddingHistoryJson'] as List?)
          ?.map((e) => (e as Map).cast<String, dynamic>())
          .toList(),
      gmpTrendHistoryTable: (json['gmpTrendHistoryTable'] as List?)
          ?.map((e) => GmpTrendHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      strengths:
          (json['strengths'] as List?)?.map((e) => e.toString()).toList(),
      objectives: (json['objectives'] as List?)
          ?.map((e) => IpoObjective.fromJson(e as Map<String, dynamic>))
          .toList(),
      companyFinancialInformationRestatedConsolidated:
          (json['companyFinancialInformationRestatedConsolidated'] as List?)
              ?.map((e) => FinancialMetricRow.fromJson(e as Map<String, dynamic>))
              .toList(),
      peerComparison: (json['peerComparison'] as List?)
          ?.map((e) => PeerComparisonRow.fromJson(e as Map<String, dynamic>))
          .toList(),
      ipoAnchorGeneralInfo: (json['ipoAnchorGeneralInfo'] as Map?)
          ?.cast<String, dynamic>(),
      companyAddress: json['companyAddress'] == null
          ? null
          : CompanyAddress.fromJson(
              json['companyAddress'] as Map<String, dynamic>,
            ),
      ipoRegistrar: json['ipoRegistrar'] == null
          ? null
          : IpoRegistrar.fromJson(json['ipoRegistrar'] as Map<String, dynamic>),
      ipoLeadManager: (json['ipoLeadManager'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      companySectorInfo: json['companySectorInfo'] == null
          ? null
          : CompanySectorInfo.fromJson(
              json['companySectorInfo'] as Map<String, dynamic>,
            ),
      ipoAnchorInvestorAllocation:
          (json['ipoAnchorInvestorAllocation'] as List?)?.toList(),
      timestamp: json['timestamp'] as String?,
      lastUpdatedDb: json['lastUpdatedDb'] as String?,
      createdAtDb: json['createdAtDb'] as String?,
      updatedAt: json['updated_at'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'ipoId': ipoId,
      'apiCompanyName': apiCompanyName,
      'apiIpoStatus': apiIpoStatus,
      'apiIpoStatusFormatted': apiIpoStatusFormatted,
      'apiListedPrice': apiListedPrice,
      'apiListingGain': apiListingGain,
      'apiGmpValue': apiGmpValue,
      'apiGmpPercent': apiGmpPercent,
      'apiFireRating': apiFireRating,
      'apiFireRatingCount': apiFireRatingCount,
      'apiSubscription': apiSubscription,
      'apiPrice': apiPrice,
      'apiEstimatedListingPrice': apiEstimatedListingPrice,
      'apiEstimatedListingPercent': apiEstimatedListingPercent,
      'apiIssueSize': apiIssueSize,
      'apiLot': apiLot,
      'apiPe': apiPe,
      'apiIssueOpenDate': apiIssueOpenDate,
      'apiIssueCloseDate': apiIssueCloseDate,
      'apiBoaDate': apiBoaDate,
      'apiListingAt': apiListingAt,
      'apiUrl': apiUrl,
      'apiIpoCategory': apiIpoCategory,
      'apiIpoYear': apiIpoYear,
      'scrapingDate': scrapingDate,
      'detailUrl': detailUrl,
      'scrapedCompanyName': scrapedCompanyName,
      'companyLogoUrl': companyLogoUrl,
      'localLogoPath': localLogoPath,
      'companyFullNameScraped': companyFullNameScraped,
      'aboutCompanyText': aboutCompanyText,
      'minOrderQuantityScraped': minOrderQuantityScraped,
      'sharesPerLotScraped': sharesPerLotScraped,
      'ipoSummaryText': ipoSummaryText,
      'ipoIssueOpeningDateStatus': ipoIssueOpeningDateStatus,
      'ipoIssueOpeningDateParsed': ipoIssueOpeningDateParsed,
      'ipoIssueClosingDateStatus': ipoIssueClosingDateStatus,
      'ipoIssueClosingDateParsed': ipoIssueClosingDateParsed,
      'ipoOpenDate': ipoOpenDate,
      'ipoCloseDate': ipoCloseDate,
      'basisOfAllotment': basisOfAllotment,
      'initiationOfRefunds': initiationOfRefunds,
      'creditOfSharesToDemat': creditOfSharesToDemat,
      'listingDate': listingDate,
      'ipoOpenDateStatus': ipoOpenDateStatus,
      'ipoOpenDateParsed': ipoOpenDateParsed,
      'ipoCloseDateStatus': ipoCloseDateStatus,
      'ipoCloseDateParsed': ipoCloseDateParsed,
      'listingDateStatus': listingDateStatus,
      'listingDateParsed': listingDateParsed,
      'basisOfAllotmentStatus': basisOfAllotmentStatus,
      'basisOfAllotmentParsed': basisOfAllotmentParsed,
      'initiationOfRefundsStatus': initiationOfRefundsStatus,
      'initiationOfRefundsParsed': initiationOfRefundsParsed,
      'creditOfSharesToDematStatus': creditOfSharesToDematStatus,
      'creditOfSharesToDematParsed': creditOfSharesToDematParsed,
      'lotIssuePrice': lotIssuePrice,
      'lotMarketLot': lotMarketLot,
      'lotRetailMin': lotRetailMin,
      'lotIndividualInvestor': lotIndividualInvestor,
      'lotMinHniLots': lotMinHniLots,
      'lotMinSmallHniLots210Lakh': lotMinSmallHniLots210Lakh,
      'lotMinBigHniLots10PlusLakh': lotMinBigHniLots10PlusLakh,
      'seq': seq,
      'idGmpData': idGmpData,
      'ipoIdGmpData': ipoIdGmpData,
      'gmpDate': gmpDate,
      'currentGmp': currentGmp,
      'gmpComments': gmpComments,
      'gmpCompareDesc': gmpCompareDesc,
      'subjectToSauda': subjectToSauda,
      'gmpCity': gmpCity,
      'gmpVariation': gmpVariation,
      'maxIpoPrice': maxIpoPrice,
      'estimatedListingPrice': estimatedListingPrice,
      'gmpPercentCalc': gmpPercentCalc,
      'gmpDescOther': gmpDescOther,
      'upDownStatus': upDownStatus,
      'gmpActiveRecordFlag': gmpActiveRecordFlag,
      'sub2SaudaRate': sub2SaudaRate,
      'estProfit': estProfit,
      'createDate': createDate,
      'createDateGmp': createDateGmp,
      'lastUpdatedGmp': lastUpdatedGmp,
      'lastUpdated': lastUpdated,
      'ipoIssueOpeningDateTable': ipoIssueOpeningDateTable,
      'ipoIssueClosingDateTable': ipoIssueClosingDateTable,
      'ipoIssuePriceTable': ipoIssuePriceTable,
      'drhpLinkTable': drhpLinkTable,
      'rhpLinkTable': rhpLinkTable,
      'anchorListLinkTable': anchorListLinkTable,
      'listingAtTable': listingAtTable,
      'retailQuotaTable': retailQuotaTable,
      'ipoIssueTypeTable': ipoIssueTypeTable,
      'ipoIssueSizeTable': ipoIssueSizeTable,
      'freshIssueTable': freshIssueTable,
      'offerForSaleTable': offerForSaleTable,
      'faceValueTable': faceValueTable,
      'ipoDiscountTable': ipoDiscountTable,
      'promoterHoldingPreIpoTable': promoterHoldingPreIpoTable,
      'promoterHoldingPostIpoTable': promoterHoldingPostIpoTable,
      'minOrderQuantityTable': minOrderQuantityTable,
      'lotSizeTable': lotSizeTable,
      'allotmentStatusTable': allotmentStatusTable,
      'ipoBseCodeTable': ipoBseCodeTable,
      'ipoNseCodeTable': ipoNseCodeTable,
      'lastUpdatedTimestamp': lastUpdatedTimestamp,
      'metaTitle': metaTitle,
      'pageTitle': pageTitle,
      'metaDesc': metaDesc,
      'cacheKey': cacheKey,
      'currentTime': currentTime,
      'scrapedAt': scrapedAt,
      'companyFullName': companyFullName,
      'companyFullNameNew': companyFullNameNew,
      'ipoAnchorText': ipoAnchorText,
      'ipoShareAllocation': ipoShareAllocation?.map((e) => e.toJson()).toList(),
      'ipoDaywiseSubscriptionTable': ipoDaywiseSubscriptionTable?.toJson(),
      'ipoSharesBidAmountTable':
          ipoSharesBidAmountTable?.map((e) => e.toJson()).toList(),
      'ipoBiddingHistoryJson': ipoBiddingHistoryJson,
      'gmpTrendHistoryTable':
          gmpTrendHistoryTable?.map((e) => e.toJson()).toList(),
      'strengths': strengths,
      'objectives': objectives?.map((e) => e.toJson()).toList(),
      'companyFinancialInformationRestatedConsolidated':
          companyFinancialInformationRestatedConsolidated
              ?.map((e) => e.toJson())
              .toList(),
      'peerComparison': peerComparison?.map((e) => e.toJson()).toList(),
      'ipoAnchorGeneralInfo': ipoAnchorGeneralInfo,
      'companyAddress': companyAddress?.toJson(),
      'ipoRegistrar': ipoRegistrar?.toJson(),
      'ipoLeadManager': ipoLeadManager,
      'companySectorInfo': companySectorInfo?.toJson(),
      'ipoAnchorInvestorAllocation': ipoAnchorInvestorAllocation,
      'timestamp': timestamp,
      'lastUpdatedDb': lastUpdatedDb,
      'createdAtDb': createdAtDb,
      'updated_at': updatedAt,
      'created_at': createdAt,
    };
  }
}

class IpoShareAllocation {
  final String? category;
  final int? sharesAllocated;
  final double? allocationPct;

  IpoShareAllocation({
    this.category,
    this.sharesAllocated,
    this.allocationPct,
  });

  factory IpoShareAllocation.fromJson(Map<String, dynamic> json) {
    return IpoShareAllocation(
      category: json['category'] as String?,
      sharesAllocated: (json['shares_allocated'] as num?)?.toInt(),
      allocationPct: (json['allocation_pct'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'category': category,
        'shares_allocated': sharesAllocated,
        'allocation_pct': allocationPct,
      };
}

class IpoDaywiseSubscriptionTable {
  final OfferedShares? offeredShares;
  final OfferedLots? offeredLots;
  final List<DaywiseSubscriptionRow>? daywiseData;

  IpoDaywiseSubscriptionTable({
    this.offeredShares,
    this.offeredLots,
    this.daywiseData,
  });

  factory IpoDaywiseSubscriptionTable.fromJson(Map<String, dynamic> json) {
    return IpoDaywiseSubscriptionTable(
      offeredShares: json['offered_shares'] == null
          ? null
          : OfferedShares.fromJson(json['offered_shares'] as Map<String, dynamic>),
      offeredLots: json['offered_lots'] == null
          ? null
          : OfferedLots.fromJson(json['offered_lots'] as Map<String, dynamic>),
      daywiseData: (json['daywise_data'] as List?)
          ?.map((e) => DaywiseSubscriptionRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'offered_shares': offeredShares?.toJson(),
        'offered_lots': offeredLots?.toJson(),
        'daywise_data': daywiseData?.map((e) => e.toJson()).toList(),
      };
}

class OfferedShares {
  final int? qibOffered;
  final int? niiOffered;
  final int? sniiOffered;
  final int? bniiOffered;
  final int? riiOffered;
  final int? totalOffered;

  OfferedShares({
    this.qibOffered,
    this.niiOffered,
    this.sniiOffered,
    this.bniiOffered,
    this.riiOffered,
    this.totalOffered,
  });

  factory OfferedShares.fromJson(Map<String, dynamic> json) {
    return OfferedShares(
      qibOffered: (json['qib_offered'] as num?)?.toInt(),
      niiOffered: (json['nii_offered'] as num?)?.toInt(),
      sniiOffered: (json['snii_offered'] as num?)?.toInt(),
      bniiOffered: (json['bnii_offered'] as num?)?.toInt(),
      riiOffered: (json['rii_offered'] as num?)?.toInt(),
      totalOffered: (json['total_offered'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'qib_offered': qibOffered,
        'nii_offered': niiOffered,
        'snii_offered': sniiOffered,
        'bnii_offered': bniiOffered,
        'rii_offered': riiOffered,
        'total_offered': totalOffered,
      };
}

class OfferedLots {
  final int? qibLots;
  final int? niiLots;
  final int? sniiLots;
  final int? bniiLots;
  final int? riiLots;
  final int? totalLots;

  OfferedLots({
    this.qibLots,
    this.niiLots,
    this.sniiLots,
    this.bniiLots,
    this.riiLots,
    this.totalLots,
  });

  factory OfferedLots.fromJson(Map<String, dynamic> json) {
    return OfferedLots(
      qibLots: (json['qib_lots'] as num?)?.toInt(),
      niiLots: (json['nii_lots'] as num?)?.toInt(),
      sniiLots: (json['snii_lots'] as num?)?.toInt(),
      bniiLots: (json['bnii_lots'] as num?)?.toInt(),
      riiLots: (json['rii_lots'] as num?)?.toInt(),
      totalLots: (json['total_lots'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'qib_lots': qibLots,
        'nii_lots': niiLots,
        'snii_lots': sniiLots,
        'bnii_lots': bniiLots,
        'rii_lots': riiLots,
        'total_lots': totalLots,
      };
}

class DaywiseSubscriptionRow {
  final int? dayNumber;
  final String? dateTime;
  final double? qibRatio;
  final double? niiRatio;
  final double? sniiRatio;
  final double? bniiRatio;
  final double? riiRatio;
  final double? totalRatio;

  DaywiseSubscriptionRow({
    this.dayNumber,
    this.dateTime,
    this.qibRatio,
    this.niiRatio,
    this.sniiRatio,
    this.bniiRatio,
    this.riiRatio,
    this.totalRatio,
  });

  factory DaywiseSubscriptionRow.fromJson(Map<String, dynamic> json) {
    return DaywiseSubscriptionRow(
      dayNumber: (json['day_number'] as num?)?.toInt(),
      dateTime: json['date_time'] as String?,
      qibRatio: (json['qib_ratio'] as num?)?.toDouble(),
      niiRatio: (json['nii_ratio'] as num?)?.toDouble(),
      sniiRatio: (json['snii_ratio'] as num?)?.toDouble(),
      bniiRatio: (json['bnii_ratio'] as num?)?.toDouble(),
      riiRatio: (json['rii_ratio'] as num?)?.toDouble(),
      totalRatio: (json['total_ratio'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'day_number': dayNumber,
        'date_time': dateTime,
        'qib_ratio': qibRatio,
        'nii_ratio': niiRatio,
        'snii_ratio': sniiRatio,
        'bnii_ratio': bniiRatio,
        'rii_ratio': riiRatio,
        'total_ratio': totalRatio,
      };
}

class IpoSharesBidAmount {
  final String? category;
  final int? sharesOffered;
  final int? sharesBid;
  final double? bidAmountCr;

  IpoSharesBidAmount({
    this.category,
    this.sharesOffered,
    this.sharesBid,
    this.bidAmountCr,
  });

  factory IpoSharesBidAmount.fromJson(Map<String, dynamic> json) {
    return IpoSharesBidAmount(
      category: json['category'] as String?,
      sharesOffered: (json['shares_offered'] as num?)?.toInt(),
      sharesBid: (json['shares_bid'] as num?)?.toInt(),
      bidAmountCr: (json['bid_amount_cr'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'category': category,
        'shares_offered': sharesOffered,
        'shares_bid': sharesBid,
        'bid_amount_cr': bidAmountCr,
      };
}

class GmpTrendHistory {
  final String? gmpDate;
  final String? ipoPrice;
  final String? gmp;
  final String? sub2SaudaRate;
  final String? estimatedListingPrice;
  final String? estimatedProfit;
  final String? lastUpdated;

  GmpTrendHistory({
    this.gmpDate,
    this.ipoPrice,
    this.gmp,
    this.sub2SaudaRate,
    this.estimatedListingPrice,
    this.estimatedProfit,
    this.lastUpdated,
  });

  factory GmpTrendHistory.fromJson(Map<String, dynamic> json) {
    return GmpTrendHistory(
      gmpDate: json['GMP Date'] as String?,
      ipoPrice: json['IPO Price'] as String?,
      gmp: json['GMP'] as String?,
      sub2SaudaRate: json['Sub2 Sauda Rate'] as String?,
      estimatedListingPrice: json['Estimated Listing Price'] as String?,
      estimatedProfit: json['Estimated Profit'] as String?,
      lastUpdated: json['Last Updated'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'GMP Date': gmpDate,
        'IPO Price': ipoPrice,
        'GMP': gmp,
        'Sub2 Sauda Rate': sub2SaudaRate,
        'Estimated Listing Price': estimatedListingPrice,
        'Estimated Profit': estimatedProfit,
        'Last Updated': lastUpdated,
      };
}

class IpoObjective {
  final String? sNo;
  final String? object;
  final String? amount;

  IpoObjective({this.sNo, this.object, this.amount});

  factory IpoObjective.fromJson(Map<String, dynamic> json) => IpoObjective(
        sNo: json['s_no'] as String?,
        object: json['object'] as String?,
        amount: json['amount'] as String?,
      );

  Map<String, dynamic> toJson() => {
        's_no': sNo,
        'object': object,
        'amount': amount,
      };
}

class FinancialMetricRow {
  final String? metric;

  // Dates are dynamic keys in your JSON like "31 Aug 2025", "31 Mar 2025"...
  // Keep them as optional strings.
  final String? d31Aug2025;
  final String? d31Mar2025;
  final String? d31Mar2024;
  final String? d31Mar2023;
  final String? d30Sep2025;

  FinancialMetricRow({
    this.metric,
    this.d31Aug2025,
    this.d31Mar2025,
    this.d31Mar2024,
    this.d31Mar2023,
    this.d30Sep2025,
  });

  factory FinancialMetricRow.fromJson(Map<String, dynamic> json) {
    return FinancialMetricRow(
      metric: json['Metric'] as String?,
      d31Aug2025: json['31 Aug 2025'] as String?,
      d30Sep2025: json['30 Sep 2025'] as String?,
      d31Mar2025: json['31 Mar 2025'] as String?,
      d31Mar2024: json['31 Mar 2024'] as String?,
      d31Mar2023: json['31 Mar 2023'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'Metric': metric,
        '31 Aug 2025': d31Aug2025,
        '30 Sep 2025': d30Sep2025,
        '31 Mar 2025': d31Mar2025,
        '31 Mar 2024': d31Mar2024,
        '31 Mar 2023': d31Mar2023,
      };
}

class PeerComparisonRow {
  final String? company;
  final String? epsBasic;
  final String? epsDiluted;
  final String? nav;
  final String? peX;
  final String? roNW;
  final String? financialStatements;

  PeerComparisonRow({
    this.company,
    this.epsBasic,
    this.epsDiluted,
    this.nav,
    this.peX,
    this.roNW,
    this.financialStatements,
  });

  factory PeerComparisonRow.fromJson(Map<String, dynamic> json) {
    return PeerComparisonRow(
      company: json['Company'] as String?,
      epsBasic: json['EPS Basic'] as String?,
      epsDiluted: json['EPS Diluted'] as String?,
      nav: json['NAV'] as String?,
      peX: json['P/E(x)'] as String?,
      roNW: json['RoNW'] as String?,
      financialStatements: json['Financial statements'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'Company': company,
        'EPS Basic': epsBasic,
        'EPS Diluted': epsDiluted,
        'NAV': nav,
        'P/E(x)': peX,
        'RoNW': roNW,
        'Financial statements': financialStatements,
      };
}

class CompanyAddress {
  final String? name;
  final String? address;
  final String? website;
  final String? phone;
  final String? email;

  CompanyAddress({this.name, this.address, this.website, this.phone, this.email});

  factory CompanyAddress.fromJson(Map<String, dynamic> json) => CompanyAddress(
        name: json['name'] as String?,
        address: json['address'] as String?,
        website: json['website'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'website': website,
        'phone': phone,
        'email': email,
      };
}

class IpoRegistrar {
  final String? name;
  final String? address;
  final String? website;
  final String? phone;
  final String? email;

  IpoRegistrar({this.name, this.address, this.website, this.phone, this.email});

  factory IpoRegistrar.fromJson(Map<String, dynamic> json) => IpoRegistrar(
        name: json['name'] as String?,
        address: json['address'] as String?,
        website: json['website'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'website': website,
        'phone': phone,
        'email': email,
      };
}

class CompanySectorInfo {
  final String? incorporation;
  final String? sector;
  final String? ipoIssueSize;
  final String? website;

  CompanySectorInfo({
    this.incorporation,
    this.sector,
    this.ipoIssueSize,
    this.website,
  });

  factory CompanySectorInfo.fromJson(Map<String, dynamic> json) =>
      CompanySectorInfo(
        incorporation: json['Incorporation'] as String?,
        sector: json['Sector'] as String?,
        ipoIssueSize: json['IPO Issue Size'] as String?,
        website: json['Website'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'Incorporation': incorporation,
        'Sector': sector,
        'IPO Issue Size': ipoIssueSize,
        'Website': website,
      };
}
