const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {GoogleGenerativeAI} = require("@google/generative-ai");
const axios = require("axios");
admin.initializeApp();

const genAI = new GoogleGenerativeAI("AIzaSyACk5PRdjpd3t7SWkuQ2lgVOp25wulGdZ0");

exports.fetchUsArticles = functions.pubsub
  .schedule('every 6 hours')
  .onRun(async (context) => {
    console.log('Function started');
    const keywords = [
      'Climate Change',
      'Global Warming',
      'Greenhouse Gases',
      'Carbon Emissions',
      'Sea Level Rise',
      'Extreme Weather',
      'Climate Policy',
      'Renewable Energy',
      'Electric Vehicles',
    ];
    console.log(`Total keywords: ${keywords.length}`);
    const baseUrl = 'https://gnews.io/api/v4/search';
     const apiKey = 'e49acee1231fca80f29f5904adbcf3b1';
    const db = admin.firestore();
    const targetCollectionName = 'Us_Climate_Change';

    for (let i = 0; i < keywords.length; i++) {
      const keyword = keywords[i];
      console.log(`Processing keyword ${i + 1}/${keywords.length}: ${keyword}`);

      try {
        const apiUrl = `${baseUrl}?q=${encodeURIComponent(keyword)}&lang=en&country=us&max=10&apikey=${apiKey}`;
        console.log(`Making API request for: ${keyword}`);

        const response = await axios.get(apiUrl);

        if (response.status === 200) {
          console.log(`Successful API response for: ${keyword}`);
          const data = response.data;
          console.log(`Articles received for ${keyword}: ${data.articles.length}`);

          for (const article of data.articles) {
            const publishedAt = new Date(article.publishedAt);
            const hourString = String(publishedAt.getUTCHours()).padStart(2, '0');
            const docId = `${article.title}-${publishedAt.toISOString().slice(0, 10)}-${hourString}`;
            const docRef = db.collection(targetCollectionName).doc(docId);

            try {
              // Add the keyword to the article object
              await docRef.set({ ...article, keyword }, { merge: false });
              console.log(`Article ${docId} stored successfully`);
            } catch (error) {
              if (error.code === 'already-exists') {
                console.log(`Article ${docId} already exists, skipping.`);
              } else {
                console.error(`Error storing article ${docId}:`, error);
              }
            }
          }

          console.log(`Articles for keyword "${keyword}" processed.`);
        } else {
          console.error(`HTTP request failed for keyword: ${keyword} - Status Code: ${response.status}`);
        }
      } catch (error) {
        console.error(`Error processing keyword "${keyword}":`, error);
      }

      console.log(`Finished processing keyword: ${keyword}`);
      await new Promise(resolve => setTimeout(resolve, 3000));
    }

    console.log('Function completed');
  });

exports.analyzeUsNews = functions.runWith({
  timeoutSeconds: 540,
  memory: '1GB'
}).pubsub.schedule("every 6 hours").onRun(async (context) => {
  const db = admin.firestore();
  const collections = [
    "Us_Climate_Change",
  ];
  for (const collectionName of collections) {
    console.log(`Processing collection: ${collectionName}`);
    const snapshot = await db.collection(collectionName).get();

    for (const doc of snapshot.docs) {
      const article = doc.data();
      // Only process articles that haven't been analyzed yet
      if (!article.summary) {
        console.log(`Analyzing document ${doc.id} in ${collectionName}`); // Added logging

        try {
          const analysis = await analyzeArticleUsGeminiAI(article);
          if (analysis) {
            // Log the analysis result
            console.log(`Analysis result for document ${doc.id}:`, analysis);

            // Update the document with new fields
            await doc.ref.update({
              summary: analysis.summary || 'unknown',
              impact: analysis.impact || 'unknown',
              degreeOfImpact: analysis.degreeOfImpact || 'unknown',
              mostAffectedCountry: analysis.mostAffectedCountry || 'unknown',
              consequences: analysis.consequences || 'unknown',
              benefitsOfAction: analysis.benefitsOfAction || 'unknown',
              urgency: analysis.urgency || 'unknown',
              responsibility: analysis.responsibility || 'unknown',
              rippleEffect : analysis.rippleEffect || 'unknown',
              responsibilityDetail : analysis.responsibilityDetail || 'unknown',
              urgencyDetail : analysis.urgencyDetail || 'unknown',
            });
            console.log(`Updated document ${doc.id} in ${collectionName}`);
          } else {
            console.error(`Failed to analyze document ${doc.id}`);
          }
        } catch (error) {
          console.error(`Error processing document ${doc.id}:`, error);
        }

        // Add a delay between requests to avoid rate limiting
        await new Promise(resolve => setTimeout(resolve, 2000));
      } else {
        console.log(`Skipping document ${doc.id} - already analyzed`); // Added logging
      }
    }
  }
  console.log("Analysis completed");
});
/**
 * Analyzes an article using the Gemini AI model.
 * @param {Object} article - The article to analyze.
 * @param {string} article.title - The title of the article.
 * @param {string} article.description - The description of the article.
 * @returns {Promise<Object>} The analysis result.
 */
async function analyzeArticleUsGeminiAI(article) {
  const model = genAI.getGenerativeModel({model: "gemini-1.5-flash"});
  const prompt = `Analyze the following news article about climate change and related topics your response should be in english language:

  URL: ${article.url || ''}

  Please provide your analysis in the following JSON format:

  {
    "summary": "A brief, jargon-free summary of the article's key findings and arguments ",
    "impact": "One-word description of the potential impact (e.g., 'positive', 'negative','no impact')",
    "degreeOfImpact":  "High, Medium, or Low ",
    "rippleEffect":  " in one short phrase explain that impact in an easy and convincing matter if there is an impact if not response with no obvious impact ",
    "mostAffectedCountry": "Up to three words identifying the most affected countries or regions if no region is detected go on a globale answer example local, regional, national, global",
    "consequences": "A description of potential negative consequences if no action is taken if there is nothing explain why ",
    "benefitsOfAction": "An outline of potential positive outcomes if appropriate actions are taken try to  Inspires hope and empowers people by highlighting pathways for mitigation and adaptation if there is nothing explain why ",
    "responsibility" : "Identify or conclude who or what the article highlights as bearing the most responsibility for addressing the climate issue. Provide a concise response, for example: Governments,Corporations,Individuals,International Cooperation,Shared .",
    "responsibilityDetail":  " in one short phrase and based on your response from the responsibility field explain why you chose it to bear the most responsibility for addressing the climate issue ",
    "urgency" : "Indicate the urgency for action using one of these phrases: Immediate Action,Urgent Response,Long-Term Action or No Action required ",
    "urgencyDetail" : "in one short phrase explain that urgency for action per example if you answer with Urgent Response convince the reader why you chose it and do the same for other keyword Immediate Action,Urgent Response,Long-Term Action or No Action required ",
  }

  Ensure all JSON fields are present and properly formatted. Do not include any additional text or formatting outside the JSON object.`;

  try {
    const result = await model.generateContent(prompt);
    const response = result.response;
    let text = response.text();

    console.log('AI response:', text); // Added logging

    // Remove any potential JSON formatting
    text = text.replace(/^```json\n|\n```$/g, '').trim();

    if (!text.startsWith("{") && !text.startsWith("[")) {
      console.error("Generated text is not valid JSON:", text);
      return null;
    }

    const parsedResponse = JSON.parse(text);

    // Validate the parsed response
    const requiredFields = ['summary', 'impact', 'degreeOfImpact', 'mostAffectedCountry', 'consequences', 'benefitsOfAction','urgency','responsibility','rippleEffect','urgencyDetail','responsibilityDetail'];
    for (const field of requiredFields) {
      if (!parsedResponse[field]) {
        console.error(`Parsed response is missing required field: ${field}`, parsedResponse);
        return null;
      }
    }

    return parsedResponse;
  } catch (error) {
    console.error("Error in analyzeArticleUsGeminiAI:", error);
    return null;
  }
}



exports.fetchChinaArticles = functions.pubsub
  .schedule("every 3 hours")
  .onRun(async (context) => {
    console.log("Function started");
    const keywords = [
            "气候变化", // Climate Change
            "全球变暖", // Global Warming
            "温室气体", // Greenhouse Gases
            "碳排放",    // Carbon Emissions
            "海平面上升", // Sea Level Rise
            "极端天气",   // Extreme Weather
            "气候政策",   // Climate Policy
            "可再生能源",  // Renewable Energy
            "电动汽车",   // Electric Vehicles
    ];
    console.log(`Total keywords: ${keywords.length}`);
    const baseUrl = "https://gnews.io/api/v4/search";
    const apiKey = "e49acee1231fca80f29f5904adbcf3b1";
    const db = admin.firestore();
    const targetCollectionName = "China_Climate_Change"; //  Target Collection
    for (let i = 0; i < keywords.length; i++) {
      const keyword = keywords[i];
      console.log(`Processing keyword ${i + 1}/${keywords.length}: ${keyword}`);
      try {
        const apiUrl = `${baseUrl}?q=${encodeURIComponent(
          keyword,
        )}&lang=zh&country=cn&max=10&apikey=${apiKey}`;
        console.log(`Making API request for: ${keyword}`);
        const response = await axios.get(apiUrl);

        if (response.status === 200) {
          console.log(`Successful API response for: ${keyword}`);
          const data = response.data;
          console.log(
            `Articles received for ${keyword}: ${data.articles.length}`,
          );

          const batch = db.batch(); // Using batch writes for efficiency

          for (const article of data.articles) {
            const publishedAt = new Date(article.publishedAt);
            const hourString = String(publishedAt.getUTCHours()).padStart(2, "0");
            const docId = `${article.title}-${publishedAt
              .toISOString()
              .slice(0, 10)}-${hourString}-${keyword.replace(/\s+/g, "_")}`;
            const docRef = db.collection(targetCollectionName).doc(docId);

            batch.set(docRef, { ...article, keyword }, { merge: false }); // Add keyword to the document
          }

          await batch.commit();
          console.log(
            `Articles for keyword "${keyword}" stored successfully in collection "${targetCollectionName}"`,
          );
        } else {
          console.error(`HTTP request failed for keyword: ${keyword}`);
        }
      } catch (error) {
        console.error(`Error processing keyword "${keyword}":`, error);
      }
      console.log(`Finished processing keyword: ${keyword}`);
    }
    console.log("Function completed");
  });

  exports.analyzeChinaNews = functions.runWith({
    timeoutSeconds: 540,
    memory: '1GB'
  }).pubsub.schedule("every 6 hours").onRun(async (context) => {
    const db = admin.firestore();
    const collections = [
      "China_Climate_Change",
    ];
    for (const collectionName of collections) {
      console.log(`Processing collection: ${collectionName}`);
      const snapshot = await db.collection(collectionName).get();

      for (const doc of snapshot.docs) {
        const article = doc.data();
        // Only process articles that haven't been analyzed yet
        if (!article.summary) {
          console.log(`Analyzing document ${doc.id} in ${collectionName}`); // Added logging

          try {
            const analysis = await analyzeArticleChinaGeminiAI(article);

            if (analysis) {
              // Log the analysis result
              console.log(`Analysis result for document ${doc.id}:`, analysis);

              // Update the document with new fields
              await doc.ref.update({
                summary: analysis.summary || 'unknown',
                impact: analysis.impact || 'unknown',
                degreeOfImpact: analysis.degreeOfImpact || 'unknown',
                mostAffectedCountry: analysis.mostAffectedCountry || 'unknown',
                consequences: analysis.consequences || 'unknown',
                benefitsOfAction: analysis.benefitsOfAction || 'unknown',
              });
              console.log(`Updated document ${doc.id} in ${collectionName}`);
            } else {
              console.error(`Failed to analyze document ${doc.id}`);
            }
          } catch (error) {
            console.error(`Error processing document ${doc.id}:`, error);
          }

          // Add a delay between requests to avoid rate limiting
          await new Promise(resolve => setTimeout(resolve, 2000));
        } else {
          console.log(`Skipping document ${doc.id} - already analyzed`); // Added logging
        }
      }
    }
    console.log("Analysis completed");
  });
  /**
   * Analyzes an article using the Gemini AI model.
   * @param {Object} article - The article to analyze.
   * @param {string} article.title - The title of the article.
   * @param {string} article.description - The description of the article.
   * @returns {Promise<Object>} The analysis result.
   */
   async function analyzeArticleChinaGeminiAI(article) {
     const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

     // Construct the prompt in Chinese
     const prompt = `分析以下关于气候变化和相关主题的中文新闻文章，并用中文给出你的回复:

       标题：${article.title}
       描述：${article.description}
       内容：${article.content || ''}
       网址：${article.url || ''}

       请以以下JSON格式提供你的分析：

       {
         "summary": "简要概括文章的关键发现和论点",
         "impact": "用一个词描述潜在影响（例如，'积极'，'消极'，'社会'，'经济'）",
         "degreeOfImpact": "高，中或低",
         "mostAffectedCountry": "最多三个词，确定受影响最大的国家或地区",
         "consequences": "如果不采取行动，可能产生的负面后果描述",
         "benefitsOfAction": "如果采取适当行动，可能产生的积极结果概述"
       }

       确保所有JSON字段都存在并且格式正确。不要在JSON对象之外包含任何其他文本或格式。`;
     try {
       const result = await model.generateContent(prompt);
       const response = result.response;
       let text = response.text();

       console.log('AI response:', text);

       // Remove any potential JSON formatting
       text = text.replace(/^```json\n|\n```$/g, '').trim();

       if (!text.startsWith("{") && !text.startsWith("[")) {
         console.error("Generated text is not valid JSON:", text);
         return null;
       }

       const parsedResponse = JSON.parse(text);

       // Validate the parsed response
       const requiredFields = ['summary', 'impact', 'degreeOfImpact', 'mostAffectedCountry', 'consequences', 'benefitsOfAction'];
       for (const field of requiredFields) {
         if (!parsedResponse[field]) {
           console.error(`Parsed response is missing required field: ${field}`, parsedResponse);
           return null;
         }
       }

       return parsedResponse;
     } catch (error) {
       console.error("Error in analyzeArticleChinaGeminiAIChinaGeminiAI:", error);
       return null;
     }
   }



  exports.fetchRussiaArticles = functions.pubsub
    .schedule("every 3 hours")
    .onRun(async (context) => {
      console.log("Function started");
      const keywords = [
      "Изменение климата", // Climate Change
      "Глобальное потепление", // Global Warming
      "Парниковые газы", // Greenhouse Gases
      "Выбросы углерода", // Carbon Emissions
      "Повышение уровня моря", // Sea Level Rise
      "Экстремальные погодные условия", // Extreme Weather
      "Климатическая политика", // Climate Policy
      "Возобновляемая энергия", // Renewable Energy
      "Электромобили", // Electric Vehicles
      ];

      console.log(`Total keywords: ${keywords.length}`);
      const baseUrl = "https://gnews.io/api/v4/search";
      const apiKey = "e49acee1231fca80f29f5904adbcf3b1";
      const db = admin.firestore();
      const targetCollectionName = "Russia_Climate_Change"; //  Target Collection

      for (let i = 0; i < keywords.length; i++) {
        const keyword = keywords[i];
        console.log(`Processing keyword ${i + 1}/${keywords.length}: ${keyword}`);
        try {
          const apiUrl = `${baseUrl}?q=${encodeURIComponent(
            keyword,
          )}&lang=ru&country=ru&max=10&apikey=${apiKey}`;
          console.log(`Making API request for: ${keyword}`);
          const response = await axios.get(apiUrl);

          if (response.status === 200) {
            console.log(`Successful API response for: ${keyword}`);
            const data = response.data;
            console.log(
              `Articles received for ${keyword}: ${data.articles.length}`,
            );

            const batch = db.batch(); // Using batch writes for efficiency

            for (const article of data.articles) {
              const publishedAt = new Date(article.publishedAt);
              const hourString = String(publishedAt.getUTCHours()).padStart(2, "0");
              const docId = `${article.title}-${publishedAt
                .toISOString()
                .slice(0, 10)}-${hourString}-${keyword.replace(/\s+/g, "_")}`;
              const docRef = db.collection(targetCollectionName).doc(docId);

              batch.set(docRef, { ...article, keyword }, { merge: false }); // Add keyword to the document
            }

            await batch.commit();
            console.log(
              `Articles for keyword "${keyword}" stored successfully in collection "${targetCollectionName}"`,
            );
          } else {
            console.error(`HTTP request failed for keyword: ${keyword}`);
          }
        } catch (error) {
          console.error(`Error processing keyword "${keyword}":`, error);
        }
        console.log(`Finished processing keyword: ${keyword}`);
      }
      console.log("Function completed");
    });
    exports.analyzeRussiaNews = functions.runWith({
      timeoutSeconds: 540,  // Increase timeout to 9 minutes
      memory: '1GB'
    }).pubsub.schedule("every 6 hours").onRun(async (context) => {
      const db = admin.firestore();
      const collections = [
        "Russia_Climate_Change",
      ];
      for (const collectionName of collections) {
        console.log(`Processing collection: ${collectionName}`);
        const snapshot = await db.collection(collectionName).get();

        for (const doc of snapshot.docs) {
          const article = doc.data();
          // Only process articles that haven't been analyzed yet
          if (!article.summary) {
            console.log(`Analyzing document ${doc.id} in ${collectionName}`); // Added logging

            try {
              const analysis = await analyzeArticle(article);

              if (analysis) {
                // Log the analysis result
                console.log(`Analysis result for document ${doc.id}:`, analysis);

                // Update the document with new fields
                await doc.ref.update({
                  summary: analysis.summary || 'unknown',
                  impact: analysis.impact || 'unknown',
                  degreeOfImpact: analysis.degreeOfImpact || 'unknown',
                  mostAffectedCountry: analysis.mostAffectedCountry || 'unknown',
                  consequences: analysis.consequences || 'unknown',
                  benefitsOfAction: analysis.benefitsOfAction || 'unknown',
                });
                console.log(`Updated document ${doc.id} in ${collectionName}`);
              } else {
                console.error(`Failed to analyze document ${doc.id}`);
              }
            } catch (error) {
              console.error(`Error processing document ${doc.id}:`, error);
            }

            // Add a delay between requests to avoid rate limiting
            await new Promise(resolve => setTimeout(resolve, 2000));
          } else {
            console.log(`Skipping document ${doc.id} - already analyzed`); // Added logging
          }
        }
      }
      console.log("Analysis completed");
    });
    /**
     * Analyzes an article using the Gemini AI model.
     * @param {Object} article - The article to analyze.
     * @param {string} article.title - The title of the article.
     * @param {string} article.description - The description of the article.
     * @returns {Promise<Object>} The analysis result.
     */

 exports.analyzeRussiaNews = functions.runWith({
    timeoutSeconds: 540,  // Increase timeout to 9 minutes
    memory: '1GB'
  }).pubsub.schedule("every 6 hours").onRun(async (context) => {
    const db = admin.firestore();
    const collections = [
      "Russia_Climate_Change",
    ];
    for (const collectionName of collections) {
      console.log(`Processing collection: ${collectionName}`);
      const snapshot = await db.collection(collectionName).get();

      for (const doc of snapshot.docs) {
        const article = doc.data();
        // Only process articles that haven't been analyzed yet
        if (!article.summary) {
          console.log(`Analyzing document ${doc.id} in ${collectionName}`); // Added logging

          try {
            const analysis = await analyzeArticleRussiaGeminiAI(article);

            if (analysis) {
              // Log the analysis result
              console.log(`Analysis result for document ${doc.id}:`, analysis);

              // Update the document with new fields
              await doc.ref.update({
                summary: analysis.summary || 'unknown',
                impact: analysis.impact || 'unknown',
                degreeOfImpact: analysis.degreeOfImpact || 'unknown',
                mostAffectedCountry: analysis.mostAffectedCountry || 'unknown',
                consequences: analysis.consequences || 'unknown',
                benefitsOfAction: analysis.benefitsOfAction || 'unknown',
              });
              console.log(`Updated document ${doc.id} in ${collectionName}`);
            } else {
              console.error(`Failed to analyze document ${doc.id}`);
            }
          } catch (error) {
            console.error(`Error processing document ${doc.id}:`, error);
          }

          // Add a delay between requests to avoid rate limiting
          await new Promise(resolve => setTimeout(resolve, 2000));
        } else {
          console.log(`Skipping document ${doc.id} - already analyzed`); // Added logging
        }
      }
    }
    console.log("Analysis completed");
  });


   async function analyzeArticleRussiaGeminiAI(article) {
     const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

     // Construct the prompt in Chinese
     const prompt = `Проанализируйте следующую новостную статью на русском языке, посвященную изменению климата и связанным с этим темам, и предоставьте ваш анализ также на русском:

       Название: ${article.title}
       Описание: ${article.description}
       Содержание: ${article.content || ''}
       URL: ${article.url || ''}

       Пожалуйста, представьте ваш анализ в следующем формате JSON:

       {
         "summary": "Краткое изложение основных выводов и аргументов статьи без использования жаргона",
         "impact": "Описание потенциального воздействия одним словом (например, 'позитивное', 'негативное', 'социальное', 'экономическое')",
         "degreeOfImpact": "Высокая, Средняя или Низкая",
         "mostAffectedCountry": "Не более трех слов, обозначающих наиболее пострадавшие страны или регионы",
         "consequences": "Описание потенциальных негативных последствий, если не будут приняты меры",
         "benefitsOfAction": "Описание потенциальных положительных результатов в случае принятия соответствующих мер"
       }

       Убедитесь, что все поля JSON присутствуют и отформатированы правильно. Не включайте никакой дополнительный текст или форматирование за пределами объекта JSON.`;
     try {
       const result = await model.generateContent(prompt);
       const response = result.response;
       let text = response.text();

       console.log('AI response:', text);

       // Remove any potential JSON formatting
       text = text.replace(/^```json\n|\n```$/g, '').trim();

       if (!text.startsWith("{") && !text.startsWith("[")) {
         console.error("Generated text is not valid JSON:", text);
         return null;
       }

       const parsedResponse = JSON.parse(text);

       // Validate the parsed response
       const requiredFields = ['summary', 'impact', 'degreeOfImpact', 'mostAffectedCountry', 'consequences', 'benefitsOfAction'];
       for (const field of requiredFields) {
         if (!parsedResponse[field]) {
           console.error(`Parsed response is missing required field: ${field}`, parsedResponse);
           return null;
         }
       }

       return parsedResponse;
     } catch (error) {
       console.error("Error in analyzeArticleRussiaGeminiAI:", error);
       return null;
     }
   }
